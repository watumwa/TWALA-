import test from "node:test";
import assert from "node:assert/strict";
import {
  initialDemoState, createBooking, acceptBooking, advanceBooking,
  verifyPickupCode, cancelBooking,
} from "../src/lib/demo-engine.ts";

const request = {
  passenger: "Amina (Demo)",
  pickup: "Hoima City Mall",
  destination: "Hoima Hospital",
  service: "boda",
  paymentMethod: "cash",
  fare: 8500,
  pairing: "standard",
};

test("pickup code is required before starting a trip", () => {
  let state = createBooking(initialDemoState(), request);
  const id = state.bookings[0].id;
  assert.match(state.bookings[0].pickupCode, /^\d{4}$/);
  state = acceptBooking(state, id, "TW-HOI-0241");
  state = advanceBooking(state, id);
  assert.equal(state.bookings[0].status, "arrived");
  assert.throws(() => advanceBooking(state, id), /Verify passenger pickup code/);
  assert.throws(() => verifyPickupCode(state, id, "0000"), /Invalid passenger pickup code/);
  state = verifyPickupCode(state, id, state.bookings[0].pickupCode);
  state = advanceBooking(state, id);
  assert.equal(state.bookings[0].status, "in_progress");
  state = advanceBooking(state, id);
  assert.equal(state.bookings[0].status, "completed");
  assert.equal(state.transactions[0].amount, 850);
});

test("direct pairing validates Captain and eligibility", () => {
  assert.throws(() => createBooking(initialDemoState(), {
    ...request, pairing: "id", requestedCaptainId: "UNKNOWN",
  }), /Captain ID not found/);
  assert.throws(() => createBooking(initialDemoState(), {
    ...request, pairing: "id", requestedCaptainId: "TW-HOI-0450",
  }), /not available or eligible/);
  const state = createBooking(initialDemoState(), {
    ...request, pairing: "id", requestedCaptainId: "TW-HOI-0241",
  });
  assert.throws(() => acceptBooking(state, state.bookings[0].id, "TW-HOI-0312"), /Wrong paired Captain|not eligible/);
});

test("route validation rejects identical locations", () => {
  assert.throws(() => createBooking(initialDemoState(), {
    ...request, destination: " hoima city mall ",
  }), /must be different/);
});

test("cancellation is permitted before trip start, not after", () => {
  let state = createBooking(initialDemoState(), request);
  const id = state.bookings[0].id;
  assert.equal(cancelBooking(state, id, "Change of plans").bookings[0].status, "cancelled");
  state = acceptBooking(state, id, "TW-HOI-0241");
  state = advanceBooking(state, id);
  state = verifyPickupCode(state, id, state.bookings[0].pickupCode);
  state = advanceBooking(state, id);
  assert.throws(() => cancelBooking(state, id, "Too late"), /have not started/);
});
