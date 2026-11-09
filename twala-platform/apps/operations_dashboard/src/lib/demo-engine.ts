/**
 * TWALA frontend-only demonstration engine.
 * Fictional records only. No PSP, GPS, authentication or production ledger.
 */
export type PaymentMethod = "cash" | "cashless" | "wallet";
export type RideService = "boda" | "car";
export type BookingStatus = "searching" | "matched" | "arrived" | "in_progress" | "completed" | "cancelled";
export type CaptainStatus = "pending" | "verified" | "suspended";
export type WithdrawalStatus = "pending" | "completed" | "failed";
export type DemoRole = "super_admin" | "operations_manager" | "finance_officer" | "verification_officer" | "customer_support" | "read_only";

export interface Captain {
  id: string; name: string; service: RideService; status: CaptainStatus;
  online: boolean; cashEligible: boolean; cashlessEligible: boolean;
  outstandingCommission: number; walletAvailable: number;
}
export interface Booking {
  id: string; passenger: string; pickup: string; destination: string;
  service: RideService; paymentMethod: PaymentMethod; fare: number;
  captainId: string | null; status: BookingStatus; createdAt: string;
  pairing: "standard" | "id" | "qr"; requestedCaptainId?: string;
  pickupCode?: string; pickupVerified?: boolean;
}
export interface WalletTransaction {
  id: string; captainId: string; kind: "deposit" | "withdrawal" | "commission" | "earning";
  amount: number; status: "pending" | "confirmed" | "failed"; reference: string;
}
export interface DemoState {
  captains: Captain[]; bookings: Booking[]; transactions: WalletTransaction[];
  nextId: number; events: string[];
}
export const DEMO_ONLY = true;
export const COMMISSION_RATE = 0.10;

export function initialDemoState(): DemoState {
  return {
    captains: [
      {id:"TW-HOI-0241",name:"Mugisa Daniel",service:"boda",status:"verified",online:true,cashEligible:true,cashlessEligible:true,outstandingCommission:0,walletAvailable:42500},
      {id:"TW-HOI-0312",name:"Nabirye Grace",service:"car",status:"verified",online:true,cashEligible:false,cashlessEligible:true,outstandingCommission:22000,walletAvailable:0},
      {id:"TW-HOI-0450",name:"Tumusiime Peter",service:"boda",status:"pending",online:false,cashEligible:false,cashlessEligible:false,outstandingCommission:0,walletAvailable:0}
    ],
    bookings: [], transactions: [], nextId: 1,
    events: ["DEMO MODE: all people, amounts, locations and transactions are fictional."]
  };
}
function record(state: DemoState, message: string): DemoState {
  return {...state, events: [message, ...state.events].slice(0, 100)};
}
function id(state: DemoState, prefix: string): string {
  return `${prefix}-${String(state.nextId).padStart(5,"0")}`;
}
export function eligibleCaptain(captain: Captain, service: RideService, payment: PaymentMethod): boolean {
  return captain.status === "verified" && captain.online && captain.service === service &&
    (payment === "cash" ? captain.cashEligible : captain.cashlessEligible);
}
export function createBooking(state: DemoState, input: Omit<Booking,"id"|"status"|"captainId"|"createdAt">): DemoState {
  if (!Number.isSafeInteger(input.fare) || input.fare <= 0) throw new Error("Fare must be a positive integer in UGX");
  if (!input.passenger.trim() || !input.pickup.trim() || !input.destination.trim()) throw new Error("Passenger and route are required");
  if(input.pairing!=="standard" && !input.requestedCaptainId) throw new Error("Captain ID required for direct pairing");
  const booking: Booking = {...input,id:id(state,"TRIP"),status:"searching",captainId:null,createdAt:new Date().toISOString(),pickupCode:String(Math.floor(1000+Math.random()*9000)),pickupVerified:false};
  return record({...state,nextId:state.nextId+1,bookings:[booking,...state.bookings]},`${booking.id} created with ${booking.paymentMethod} selected before matching`);
}
export function acceptBooking(state: DemoState, bookingId: string, captainId: string): DemoState {
  const booking=state.bookings.find(b=>b.id===bookingId);
  const captain=state.captains.find(c=>c.id===captainId);
  if(!booking || !captain) throw new Error("Booking or Captain not found");
  if(booking.status!=="searching") throw new Error("Booking is no longer available for acceptance");
  if(!eligibleCaptain(captain,booking.service,booking.paymentMethod)) throw new Error("Captain is not eligible for this payment method");
  if(booking.pairing!=="standard" && booking.requestedCaptainId!==captainId) throw new Error("Wrong paired Captain");
  if(state.bookings.some(b=>b.id!==bookingId && b.captainId===captainId && ["matched","arrived","in_progress"].includes(b.status))) throw new Error("Captain already has an active trip");
  return record({...state,bookings:state.bookings.map(b=>b.id===bookingId?{...b,status:"matched",captainId}:b)},`${captainId} accepted ${bookingId}`);
}
export function advanceBooking(state: DemoState, bookingId: string): DemoState {
  const booking=state.bookings.find(b=>b.id===bookingId);
  if(!booking) throw new Error("Booking not found");
  const next: Partial<Record<BookingStatus,BookingStatus>>={matched:"arrived",arrived:"in_progress",in_progress:"completed"};
  if (booking.status === "arrived" && !booking.pickupVerified) throw new Error("Verify passenger pickup code before starting the trip");
  const status=next[booking.status];
  if(!status) throw new Error("Invalid trip status transition");
  let result: DemoState={...state,bookings:state.bookings.map(b=>b.id===bookingId?{...b,status}:b)};
  if(status==="completed" && booking.captainId){
    const commission=Math.round(booking.fare*COMMISSION_RATE);
    const captainShare=booking.fare-commission;
    const captainId=booking.captainId;
    result={...result,captains:result.captains.map(c=>{
      if(c.id!==captainId) return c;
      if(booking.paymentMethod==="cash") return {...c,outstandingCommission:c.outstandingCommission+commission,cashEligible:c.outstandingCommission+commission<20000};
      return {...c,walletAvailable:c.walletAvailable+captainShare};
    }),transactions:[...result.transactions,
      {id:id(result,"TX"),captainId,kind:booking.paymentMethod==="cash"?"commission":"earning",amount:booking.paymentMethod==="cash"?commission:captainShare,status:"confirmed",reference:booking.id}
    ],nextId:result.nextId+1};
  }
  return record(result,`${bookingId} moved to ${status}`);
}
export function confirmDeposit(state: DemoState, captainId: string, amount: number, confirmed: boolean): DemoState {
  if(!Number.isSafeInteger(amount)||amount<=0) throw new Error("Invalid deposit amount");
  if(!state.captains.some(c=>c.id===captainId)) throw new Error("Captain not found");
  const reference=id(state,"DEP");
  const next={...state,nextId:state.nextId+1,
    captains:state.captains.map(c=>c.id===captainId && confirmed?{...c,walletAvailable:c.walletAvailable+amount}:c),
    transactions:[...state.transactions,{id:reference,captainId,kind:"deposit" as const,amount,status:confirmed?"confirmed" as const:"failed" as const,reference}]};
  return record(next,`${reference}: deposit ${confirmed?"confirmed":"failed"}`);
}
export function requestWithdrawal(state: DemoState, captainId: string, amount: number): DemoState {
  if(!Number.isSafeInteger(amount)||amount<=0) throw new Error("Invalid withdrawal amount");
  const captain=state.captains.find(c=>c.id===captainId);
  if(!captain || captain.walletAvailable<amount) throw new Error("Insufficient available wallet funds");
  const reference=id(state,"WDR");
  return record({...state,nextId:state.nextId+1,
    captains:state.captains.map(c=>c.id===captainId?{...c,walletAvailable:c.walletAvailable-amount}:c),
    transactions:[...state.transactions,{id:reference,captainId,kind:"withdrawal",amount,status:"pending",reference}]
  },`${reference}: withdrawal reserved`);
}
export function resolveWithdrawal(state: DemoState, reference: string, success: boolean): DemoState {
  const transaction=state.transactions.find(t=>t.reference===reference&&t.kind==="withdrawal");
  if(!transaction||transaction.status!=="pending") throw new Error("Withdrawal not pending");
  return record({...state,
    transactions:state.transactions.map(t=>t.reference===reference?{...t,status:success?"confirmed":"failed"} as WalletTransaction:t),
    captains:success?state.captains:state.captains.map(c=>c.id===transaction.captainId?{...c,walletAvailable:c.walletAvailable+transaction.amount}:c)
  },`${reference}: withdrawal ${success?"completed":"failed and funds restored"}`);
}
export function setCaptainVerification(state: DemoState, captainId: string, status: CaptainStatus): DemoState {
  if(!state.captains.some(c=>c.id===captainId)) throw new Error("Captain not found");
  return record({...state,captains:state.captains.map(c=>c.id===captainId?{...c,status,online:status==="verified"&&c.online}:c)},`${captainId}: verification ${status}`);
}

/** Demo-only Captain availability; does not update GPS or authenticate identity. */
export function setCaptainOnline(state: DemoState, captainId: string, online: boolean): DemoState {
  const captain = state.captains.find(c => c.id === captainId);
  if (!captain) throw new Error("Captain not found");
  if (online && captain.status !== "verified") throw new Error("Captain must be verified to go online");
  if (!online && state.bookings.some(b => b.captainId === captainId &&
    ["matched", "arrived", "in_progress"].includes(b.status))) {
    throw new Error("Complete the active trip before going offline");
  }
  return record({...state, captains: state.captains.map(c =>
    c.id === captainId ? {...c, online} : c)},
    `${captainId} went ${online ? "online" : "offline"}`);
}

/** Cancel only before trip start; no demo wallet movements are generated. */
export function cancelBooking(state: DemoState, bookingId: string, reason: string): DemoState {
  const booking = state.bookings.find(b => b.id === bookingId);
  if (!booking) throw new Error("Booking not found");
  if (!["searching", "matched", "arrived"].includes(booking.status)) {
    throw new Error("Only bookings that have not started can be cancelled");
  }
  const safeReason = reason.trim();
  if (!safeReason || safeReason.length > 160) throw new Error("Cancellation reason must be 1–160 characters");
  return record({
    ...state,
    bookings: state.bookings.map(b => b.id === bookingId
      ? {...b, status: "cancelled" as const} : b),
  }, `${bookingId} cancelled: ${safeReason}`);
}

/** Prototype-only pickup code check. Real deployments require authenticated identities and secret storage. */
export function verifyPickupCode(state: DemoState, bookingId: string, code: string): DemoState {
  const booking = state.bookings.find(b => b.id === bookingId);
  if (!booking) throw new Error("Booking not found");
  if (booking.status !== "arrived") throw new Error("Captain must arrive before pickup verification");
  if (booking.pickupVerified) throw new Error("Pickup is already verified");
  if (!/^\\d{4}$/.test(code) || code !== booking.pickupCode) throw new Error("Invalid passenger pickup code");
  return record({...state, bookings: state.bookings.map(b =>
    b.id === bookingId ? {...b, pickupVerified: true} : b)}, `${bookingId}: passenger pickup verified`);
}
