const fs=require('fs'),assert=require('assert');
const base='C:/Work/assignment_3/wavedrom-verified';
const symbols=JSON.parse(fs.readFileSync(base+'/signal-values.json'));
const lines=fs.readFileSync(base+'/64-trace.csv','utf8').trim().split(/\r?\n/), keys=lines.shift().split(',');
const rows=new Map(lines.map(l=>{const r=Object.fromEntries(l.split(',').map((v,i)=>[keys[i],v]));return[+r.half,r];}));
const cycles=[-1,0,1,63,64,65,127,128,129,191,192,255,256], slots=[];
cycles.forEach((c,i)=>{if(i&&c!==cycles[i-1]+1)slots.push(null,null);slots.push(2*c,2*c+1);});
const sym=(v,t)=>/^0+$/.test(v)?'0':Object.keys(t).find(k=>t[k]===v);
const names=['IDLE','RUN_G0','RUN_G1','RUN_BOTH'];
const color=v=>v==='RUN_BOTH'||/^[DH]2$/.test(v)?'5':v==='RUN_G0'||/^[DH]0$/.test(v)?'3':v==='RUN_G1'||/^[DH]1$/.test(v)?'4':'2';
let count=0;
function lane(name,fn,binary=false){let previous,wave='',data=[],inGap=false;for(const h of slots){if(h===null){wave+=inGap?'.':'|';inGap=true;continue;}inGap=false;const v=String(fn(h));assert(v!=='undefined');if(v===previous)wave+='.';else if(binary)wave+=v;else{wave+=color(v);data.push(v);}previous=v;}let di=0,value;[...wave].forEach((w,i)=>{if(slots[i]===null)return;if(w==='0'||w==='1')value=w;else if(w!=='.')value=data[di++];assert.strictEqual(value,String(fn(slots[i])));count++;});return{name,wave,...(binary?{}:{data}),period:0.5};}
const result={signal:[lane('Cycle',h=>Math.floor(h/2)),lane('ena',h=>rows.get(h).ena,true),lane('rdy',h=>rows.get(h).rdy,true),lane('dout',h=>sym(rows.get(h).dout,symbols.hashes)),lane('din',h=>sym(rows.get(h).din,symbols.inputs)),lane('current state',h=>names[+rows.get(h).cstate])],head:{text:'Input interval = 64 cycles'},foot:{text:'Each character = half a clock; | = omitted cycles'},config:{hscale:1}};
assert(result.signal.every(l=>l.wave.length===34));
const txt='{\n  "signal": [\n'+result.signal.map(s=>'    '+JSON.stringify(s)).join(',\n')+'\n  ],\n  "head": '+JSON.stringify(result.head)+',\n  "foot": '+JSON.stringify(result.foot)+',\n  "config": '+JSON.stringify(result.config)+'\n}';
fs.writeFileSync('C:/Work/assignment_3/wavedrom-compact/64-half-aligned.json',txt+'\n');
console.log(txt);console.log('Verified '+count+' samples.');
