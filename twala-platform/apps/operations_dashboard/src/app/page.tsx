"use client";
import {useEffect,useMemo,useState} from "react";
import {initialDemoState,eligibleCaptain,type DemoRole,type DemoState,type PaymentMethod,type RideService} from "@/lib/demo-engine";

const sections=["Overview","Live operations","Trips","Captains","Passengers","Verification","Wallet & finance","Complaints","Reports","Access & audit"] as const;
type Section=typeof sections[number];
const permissions:Record<DemoRole,Section[]>={
 super_admin:[...sections],
 operations_manager:["Overview","Live operations","Trips","Captains","Passengers","Verification","Complaints","Reports","Access & audit"],
 finance_officer:["Overview","Trips","Wallet & finance","Reports","Access & audit"],
 verification_officer:["Overview","Captains","Verification","Access & audit"],
 customer_support:["Overview","Trips","Passengers","Complaints","Access & audit"],
 read_only:["Overview","Live operations","Trips","Captains","Passengers","Reports","Access & audit"]
};
const money=(v:number)=>"UGX "+v.toLocaleString("en-UG");
export default function Home(){
 const [state,setState]=useState<DemoState>(initialDemoState);
 const [syncing,setSyncing]=useState(true);
 const [apiError,setApiError]=useState("");
 useEffect(()=>{
  let active=true;
  const refresh=async()=>{
   try{
    const response=await fetch("/api/demo",{cache:"no-store"});
    if(!response.ok)throw new Error("Unable to load shared demo state");
    const data=await response.json() as {state:DemoState};
    if(active){setState(data.state);setApiError("");}
   }catch(error){if(active)setApiError(error instanceof Error?error.message:"Connection unavailable");}
   finally{if(active)setSyncing(false);}
  };
  void refresh();
  const timer=setInterval(()=>void refresh(),3000);
  return ()=>{active=false;clearInterval(timer);};
 },[]);
 const [role,setRole]=useState<DemoRole>("super_admin");
 const [section,setSection]=useState<Section>("Overview");
 const [message,setMessage]=useState("");
 const [service,setService]=useState<RideService>("boda");
 const [payment,setPayment]=useState<PaymentMethod>("cash");
 const [captain,setCaptain]=useState("TW-HOI-0241");
 const [amount,setAmount]=useState(10000);
 const allowed=permissions[role];
 const selected=allowed.includes(section)?section:"Overview";
 const completed=state.bookings.filter(b=>b.status==="completed");
 const revenue=completed.reduce((sum,b)=>sum+b.fare,0);
 const commission=completed.reduce((sum,b)=>sum+Math.round(b.fare*.1),0);
 const eligible=useMemo(()=>state.captains.filter(c=>eligibleCaptain(c,service,payment)),[state,service,payment]);
 async function apply(action:Record<string,unknown>){
  try{
   const response=await fetch("/api/demo",{method:"POST",headers:{"Content-Type":"application/json"},body:JSON.stringify(action),cache:"no-store"});
   const data=await response.json() as {state?:DemoState;error?:string};
   if(!response.ok||!data.state)throw new Error(data.error||"Demo action failed");
   setState(data.state);setApiError("");setMessage(data.state.events[0]||"Action completed");
  }catch(error){setMessage(error instanceof Error?error.message:"Demo action failed");}
 }
 function create(){void apply({action:"create_booking",passenger:"Demo Passenger",pickup:"Hoima Central Market",destination:"Hoima Regional Referral Hospital",service,paymentMethod:payment,fare:service==="boda"?8500:24000,pairing:"standard"});setSection("Trips");}
 const nav=(label:Section)=>{if(allowed.includes(label)){setSection(label);setMessage("");}};
 return <div className="shell">
  <aside className="sidebar"><div className="brand"><div className="brand-mark">T</div><div><strong>TWALA</strong><small>OPERATIONS CENTER</small></div></div><div className="demo-flag">● DEMO MODE · FICTIONAL DATA</div>
  <div className="nav-heading">WORKSPACE</div><nav>{sections.filter(s=>allowed.includes(s)).map(s=><button key={s} className={selected===s?"nav active":"nav"} onClick={()=>nav(s)}><span className="nav-dot"/>{s}</button>)}</nav>
  <div className="sidebar-bottom"><span className="avatar">TW</span><div><strong>TWALA Operations</strong><small>{role.replaceAll("_"," ")}</small></div></div></aside>
  <main className="main"><header className="topbar"><div><div className="eyebrow">TWALA / OPERATIONS</div><h1>{selected}</h1><p>Hoima City · Interactive stakeholder demonstration</p></div><div className="top-actions"><label className="role-label">View as <select aria-label="Demo role" value={role} onChange={e=>setRole(e.target.value as DemoRole)}>{Object.keys(permissions).map(r=><option key={r} value={r}>{r.replaceAll("_"," ")}</option>)}</select></label><span className="demo-pill">SIMULATED</span></div></header>
  {syncing&&<div className="notice" role="status">Connecting to shared TWALA demo API…</div>}
  {apiError&&<div className="notice" role="alert">Shared demo API unavailable: {apiError}. Displaying last loaded data.</div>}
  {message&&<div className="notice" role="status">{message}<button onClick={()=>setMessage("")} aria-label="Dismiss">×</button></div>}
  {selected==="Overview"&&<><div className="metrics"><Metric title="Total demo bookings" value={String(state.bookings.length)} note="Simulated trips"/><Metric title="Active trips" value={String(state.bookings.filter(b=>!["completed","cancelled"].includes(b.status)).length)} note="Awaiting or underway"/><Metric title="Completed fare value" value={money(revenue)} note="Fictional, not settled"/><Metric title="TWALA commission" value={money(commission)} note="10% of completed fares"/></div><div className="columns"><div className="panel"><h2>Quick demonstration booking</h2><p className="muted">Create a fictional booking with payment locked before Captain matching.</p><div className="form-grid"><label>Service<select value={service} onChange={e=>setService(e.target.value as RideService)}><option value="boda">Boda-boda</option><option value="car">Car</option></select></label><label>Payment method<select value={payment} onChange={e=>setPayment(e.target.value as PaymentMethod)}><option value="cash">Cash</option><option value="cashless">Mobile Money (simulated)</option><option value="wallet">Wallet (simulated)</option></select></label></div><p className="hint">{eligible.length} eligible Captain(s) for this service and payment method.</p><button className="primary" onClick={create}>Create demo booking</button></div><div className="panel"><h2>Activity feed</h2><div className="activity">{state.events.slice(0,6).map((event,i)=><div key={i} className="activity-item"><span className="activity-dot"/>{event}</div>)}</div></div></div></>}
  {selected==="Trips"&&<div className="panel"><div className="panel-head"><div><h2>Trip management</h2><p className="muted">Accept and advance simulated trip requests</p></div><button className="secondary" onClick={()=>setSection("Overview")}>New booking</button></div><div className="table-wrap"><table><thead><tr><th>Trip</th><th>Service</th><th>Payment</th><th>Fare</th><th>Captain</th><th>Status</th><th>Action</th></tr></thead><tbody>{state.bookings.map(b=><tr key={b.id}><td><strong>{b.id}</strong><small>{b.pickup} → {b.destination}</small></td><td>{b.service}</td><td>{b.paymentMethod}</td><td>{money(b.fare)}</td><td>{b.captainId||"Unassigned"}</td><td><span className="status">{b.status.replaceAll("_"," ")}</span></td><td>{b.status==="searching"?<select aria-label={"Accept "+b.id} defaultValue="" onChange={e=>{if(e.target.value)void apply({action:"accept_booking",bookingId:b.id,captainId:e.target.value});}}><option value="">Assign Captain…</option>{state.captains.filter(c=>eligibleCaptain(c,b.service,b.paymentMethod)).map(c=><option key={c.id} value={c.id}>{c.name}</option>)}</select>:["matched","arrived","in_progress"].includes(b.status)?<button className="small-btn" onClick={()=>void apply({action:"advance_booking",bookingId:b.id})}>Advance →</button>:"—"}{["searching","matched","arrived"].includes(b.status)&&<button className="small-btn" onClick={()=>{const reason=window.prompt("Reason for cancelling "+b.id+" (required):");if(reason!==null)void apply({action:"cancel_booking",bookingId:b.id,reason});}}>Cancel</button>}</td></tr>)}</tbody></table>{!state.bookings.length&&<Empty text="No bookings yet. Create one from Overview."/ >}</div></div>}
  {selected==="Captains"&&<div className="panel"><h2>Captain directory</h2><div className="table-wrap"><table><thead><tr><th>Captain</th><th>Service</th><th>Verification</th><th>Availability</th><th>Cash eligible</th><th>Commission owed</th></tr></thead><tbody>{state.captains.map(c=><tr key={c.id}><td><strong>{c.name}</strong><small>{c.id}</small></td><td>{c.service}</td><td><span className="status">{c.status}</span></td><td>{c.online?"Online":"Offline"}</td><td>{c.cashEligible?"Yes":"No"}</td><td>{money(c.outstandingCommission)}</td></tr>)}</tbody></table></div></div>}
  {selected==="Verification"&&<div className="panel"><h2>Captain document verification</h2><p className="muted">Demonstration decisions; no real identity checks.</p>{state.captains.map(c=><div className="list-row" key={c.id}><div><strong>{c.name}</strong><small>{c.id} · {c.status}</small></div><div className="button-group"><button className="secondary" onClick={()=>void apply({action:"set_verification",captainId:c.id,status:"verified"})}>Approve</button><button className="secondary" onClick={()=>void apply({action:"set_verification",captainId:c.id,status:"pending"})}>Request information</button><button className="secondary" onClick={()=>void apply({action:"set_verification",captainId:c.id,status:"suspended"})}>Suspend</button></div></div>)}</div>}
  {selected==="Wallet & finance"&&<><div className="metrics"><Metric title="Completed trip value" value={money(revenue)} note="Fictional"/><Metric title="10% commission" value={money(commission)} note="Illustrative allocation"/><Metric title="Outstanding cash commission" value={money(state.captains.reduce((a,c)=>a+c.outstandingCommission,0))} note="Not real receivables"/><Metric title="Demo transactions" value={String(state.transactions.length)} note="In-memory only"/></div><div className="panel"><h2>Wallet simulation</h2><div className="form-grid"><label>Captain<select value={captain} onChange={e=>setCaptain(e.target.value)}>{state.captains.map(c=><option key={c.id} value={c.id}>{c.name}</option>)}</select></label><label>Amount (UGX)<input type="number" min="1" step="1" value={amount} onChange={e=>setAmount(Number(e.target.value))}/></label></div><div className="button-group"><button className="primary" onClick={()=>void apply({action:"confirm_deposit",captainId:captain,amount,confirmed:true})}>Confirm demo deposit</button><button className="secondary" onClick={()=>void apply({action:"confirm_deposit",captainId:captain,amount,confirmed:false})}>Fail demo deposit</button><button className="secondary" onClick={()=>void apply({action:"request_withdrawal",captainId:captain,amount})}>Reserve withdrawal</button></div><h3>Transactions</h3><div className="table-wrap"><table><thead><tr><th>Reference</th><th>Captain</th><th>Type</th><th>Amount</th><th>Status</th><th>Action</th></tr></thead><tbody>{state.transactions.map(t=><tr key={t.id}><td>{t.reference}</td><td>{t.captainId}</td><td>{t.kind}</td><td>{money(t.amount)}</td><td><span className="status">{t.status}</span></td><td>{t.kind==="withdrawal"&&t.status==="pending"?<div className="button-group"><button className="small-btn" onClick={()=>void apply({action:"resolve_withdrawal",reference:t.reference,success:true})}>Confirm</button><button className="small-btn" onClick={()=>void apply({action:"resolve_withdrawal",reference:t.reference,success:false})}>Fail / restore</button></div>:"—"}</td></tr>)}</tbody></table>{!state.transactions.length&&<Empty text="No demo wallet transactions yet."/>}</div></div></>}
  {selected==="Live operations"&&<div className="panel"><h2>Hoima operational overview</h2><div className="map-placeholder"><span>HOIMA CITY</span><strong>Live map demonstration</strong><p>Real GPS and map integrations are not connected.</p><div className="map-pins">{state.captains.filter(c=>c.online).map(c=><span key={c.id}>● {c.name} · {c.service}</span>)}</div></div></div>}
  {selected==="Passengers"&&<div className="panel"><h2>Passenger records</h2><div className="list-row"><div><strong>Demo Passenger</strong><small>Fictional account · Hoima City</small></div><span className="status">{state.bookings.length} bookings</span></div></div>}
  {selected==="Complaints"&&<div className="panel"><h2>Support and safety cases</h2><Empty text="No fictional complaints recorded. Case workflow will be added in a subsequent milestone."/></div>}
  {selected==="Reports"&&<div className="panel"><h2>Operational report</h2><p className="muted">Demo figures only; not accounting or financial reporting.</p><div className="metrics"><Metric title="Trips" value={String(state.bookings.length)} note="Created"/><Metric title="Completed" value={String(completed.length)} note="Simulated"/><Metric title="Gross fares" value={money(revenue)} note="Fictional"/></div><button className="secondary" onClick={()=>{const rows=[["trip","status","fare_ugx","payment"],...state.bookings.map(b=>[b.id,b.status,String(b.fare),b.paymentMethod])];const csv=rows.map(r=>r.join(",")).join("\n");const a=document.createElement("a");a.href=URL.createObjectURL(new Blob([csv],{type:"text/csv"}));a.download="twala-demo-trips.csv";a.click();URL.revokeObjectURL(a.href);}}>Export demo CSV</button></div>}
  {selected==="Access & audit"&&<div className="panel"><h2>Role permissions and activity</h2><p className="muted">Change the role selector above to test restricted navigation.</p><p><strong>Current role:</strong> {role.replaceAll("_"," ")}</p><p><strong>Available modules:</strong> {allowed.join(", ")}</p><h3>Demo audit events</h3><div className="activity">{state.events.map((e,i)=><div key={i} className="activity-item"><span className="activity-dot"/>{e}</div>)}</div></div>}
  <footer>TWALA Mobility (U) Ltd · Interactive prototype · All records and balances are fictional · No real payment processing</footer>
  </main></div>;
}
function Metric({title,value,note}:{title:string,value:string,note:string}){return <div className="metric"><span>{title}</span><strong>{value}</strong><small>{note}</small></div>}
function Empty({text}:{text:string}){return <div className="empty">{text}</div>}
