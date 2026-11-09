import { NextResponse } from "next/server";
import {
  acceptBooking, advanceBooking, confirmDeposit, createBooking,
  initialDemoState, requestWithdrawal, resolveWithdrawal,
  setCaptainVerification, setCaptainOnline, cancelBooking,
  type Booking, type CaptainStatus, type DemoState,
} from "@/lib/demo-engine";

// Prototype-only shared state: resets on server restart and is not durable.
// Single-process demo only; not a production booking, payment, or identity API.
const globalDemo = globalThis as typeof globalThis & { __twalaDemoState?: DemoState };
const current = () => (globalDemo.__twalaDemoState ??= initialDemoState());
const respond = () => NextResponse.json({ demo: true, state: current() }, {
  headers: { "Cache-Control": "no-store" },
});

export async function GET() {
  return respond();
}

export async function POST(request: Request) {
  let body: Record<string, unknown>;
  try {
    const parsed: unknown = await request.json();
    if (!parsed || typeof parsed !== "object" || Array.isArray(parsed)) {
      return NextResponse.json({ error: "Expected a JSON object" }, { status: 400 });
    }
    body = parsed as Record<string, unknown>;
  } catch {
    return NextResponse.json({ error: "Invalid JSON" }, { status: 400 });
  }
  const str = (key: string): string => {
    if (typeof body[key] !== "string") throw new Error(key + " must be a string");
    return body[key] as string;
  };
  const num = (key: string): number => {
    if (typeof body[key] !== "number") throw new Error(key + " must be a number");
    return body[key] as number;
  };
  try {
    const state = current();
    let next: DemoState;
    switch (body.action) {
      case "create_booking": {
        const service = str("service");
        const paymentMethod = str("paymentMethod");
        const pairing = str("pairing");
        if (!["boda", "car"].includes(service) ||
            !["cash", "cashless", "wallet"].includes(paymentMethod) ||
            !["standard", "id", "qr"].includes(pairing)) {
          throw new Error("Invalid service, payment method, or pairing");
        }
        const input = {
          passenger: str("passenger"),
          pickup: str("pickup"),
          destination: str("destination"),
          fare: num("fare"),
          service: service as Booking["service"],
          paymentMethod: paymentMethod as Booking["paymentMethod"],
          pairing: pairing as Booking["pairing"],
          ...(body.requestedCaptainId === undefined ? {} : { requestedCaptainId: str("requestedCaptainId") }),
        };
        next = createBooking(state, input);
        break;
      }
      case "cancel_booking":
        next = cancelBooking(state, str("bookingId"), str("reason"));
        break;
      case "accept_booking":
        next = acceptBooking(state, str("bookingId"), str("captainId"));
        break;
      case "advance_booking":
        next = advanceBooking(state, str("bookingId"));
        break;
      case "confirm_deposit":
        if (typeof body.confirmed !== "boolean") throw new Error("confirmed must be a boolean");
        next = confirmDeposit(state, str("captainId"), num("amount"), body.confirmed);
        break;
      case "request_withdrawal":
        next = requestWithdrawal(state, str("captainId"), num("amount"));
        break;
      case "resolve_withdrawal":
        if (typeof body.success !== "boolean") throw new Error("success must be a boolean");
        next = resolveWithdrawal(state, str("reference"), body.success);
        break;
      case "set_verification": {
        const status = str("status");
        if (!["pending", "verified", "suspended"].includes(status)) throw new Error("Invalid verification status");
        next = setCaptainVerification(state, str("captainId"), status as CaptainStatus);
        break;
      }
      case "set_captain_online":
        if (typeof body.online !== "boolean") throw new Error("online must be a boolean");
        next = setCaptainOnline(state, str("captainId"), body.online);
        break;
      case "reset":
        next = initialDemoState();
        break;
      default:
        return NextResponse.json({ error: "Unknown demo action" }, { status: 400 });
    }
    globalDemo.__twalaDemoState = next;
    return respond();
  } catch (error) {
    return NextResponse.json({ error: error instanceof Error ? error.message : "Invalid demo action" }, { status: 400 });
  }
}
