import test from "node:test";
import type {DemoState} from "./demo-engine.ts";
import assert from "node:assert/strict";
import {initialDemoState,createBooking,acceptBooking,advanceBooking,verifyPickupCode,confirmDeposit,requestWithdrawal,resolveWithdrawal,eligibleCaptain} from "./demo-engine.ts";
const booking=(state:DemoState,extra:Record<string,unknown>={})=>createBooking(state,{passenger:"Demo Passenger",pickup:"Hoima Market",destination:"Hospital",service:"boda",paymentMethod:"cash",fare:10000,pairing:"standard",...extra});
test("payment selected before matching and captain acceptance required",()=>{
 let s=booking(initialDemoState());
 assert.equal(s.bookings[0].status,"searching");
 assert.equal(s.bookings[0].paymentMethod,"cash");
 assert.throws(()=>advanceBooking(s,s.bookings[0].id),/Invalid trip/);
 s=acceptBooking(s,s.bookings[0].id,"TW-HOI-0241");
 assert.equal(s.bookings[0].status,"matched");
 assert.throws(()=>acceptBooking(s,s.bookings[0].id,"TW-HOI-0241"),/no longer available/);
});
test("direct pairing cannot be accepted by another Captain",()=>{
 let s=booking(initialDemoState(),{pairing:"id",requestedCaptainId:"TW-HOI-0241"});
 assert.throws(()=>acceptBooking(s,s.bookings[0].id,"TW-HOI-0312"));
 s=acceptBooking(s,s.bookings[0].id,"TW-HOI-0241");
 assert.equal(s.bookings[0].captainId,"TW-HOI-0241");
});
test("cash trip allocates 10% commission once",()=>{
 let s=booking(initialDemoState());
 const trip=s.bookings[0].id;
 s=acceptBooking(s,trip,"TW-HOI-0241");
 s=advanceBooking(s,trip);
 s=verifyPickupCode(s,trip,s.bookings[0].pickupCode!);
 s=advanceBooking(s,trip);
 s=advanceBooking(s,trip);
 assert.equal(s.captains[0].outstandingCommission,1000);
 assert.equal(s.transactions.length,1);
 assert.throws(()=>advanceBooking(s,trip),/Invalid trip/);
});
test("cashless captain cannot accept cash trip",()=>{
 let s=booking(initialDemoState(),{service:"car"});
 assert.throws(()=>acceptBooking(s,s.bookings[0].id,"TW-HOI-0312"),/not eligible/);
 s=booking(initialDemoState(),{service:"car",paymentMethod:"cashless"});
 s=acceptBooking(s,s.bookings[0].id,"TW-HOI-0312");
 assert.equal(s.bookings[0].status,"matched");
});
test("failed deposit leaves wallet unchanged",()=>{
 const s=initialDemoState();
 const next=confirmDeposit(s,"TW-HOI-0241",5000,false);
 assert.equal(next.captains[0].walletAvailable,s.captains[0].walletAvailable);
 assert.equal(next.transactions[0].status,"failed");
});
test("withdrawal reserves and restores funds on failure",()=>{
 let s=initialDemoState();
 s=requestWithdrawal(s,"TW-HOI-0241",10000);
 assert.equal(s.captains[0].walletAvailable,32500);
 const ref=s.transactions[0].reference;
 s=resolveWithdrawal(s,ref,false);
 assert.equal(s.captains[0].walletAvailable,42500);
 assert.throws(()=>resolveWithdrawal(s,ref,false),/not pending/);
});
test("Captain cannot hold concurrent active trips",()=>{
 let s=booking(initialDemoState());const first=s.bookings[0].id;
 s=acceptBooking(s,first,"TW-HOI-0241");
 s=booking(s);assert.throws(()=>acceptBooking(s,s.bookings[0].id,"TW-HOI-0241"),/active trip/);
});
test("invalid fares and missing direct pairing IDs are rejected",()=>{
 assert.throws(()=>booking(initialDemoState(),{fare:-1}),/positive integer/);
 assert.throws(()=>booking(initialDemoState(),{pairing:"qr"}),/Captain ID required/);
});
