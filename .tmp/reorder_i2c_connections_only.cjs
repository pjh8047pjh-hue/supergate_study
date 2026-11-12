const fs=require('fs');
const path=require('path');
const dir='C:/Work/assignment_6/i2c_rx_assignment/design/rtl';
const backup='C:/Work/.tmp/i2c_order_before';
const files=fs.readdirSync(backup).filter(n=>n.endsWith('.v'));
const original=Object.fromEntries(files.map(n=>[n,fs.readFileSync(path.join(backup,n),'latin1')]));
const current=Object.fromEntries(files.map(n=>[n,fs.readFileSync(path.join(dir,n),'latin1')]));
function close(s,start){let d=0;for(let i=start;i<s.length;i++){if(s[i]==='(')d++;else if(s[i]===')'&&--d===0)return i;}throw Error('Unbalanced parentheses');}
const orders={};
for(const s of Object.values(original)){
 const m=/\bmodule\s+(\w+)\s*/.exec(s);let start=m.index+m[0].length;
 if(s[start]==='#'){start=close(s,s.indexOf('(',start))+1;while(/\s/.test(s[start]))start++;}
 const end=close(s,start);
 orders[m[1]]=s.slice(start+1,end).replace(/\/\/[^\r\n]*/g,'').split(',').map(x=>x.trim().match(/\w+$/)[0]);
}
const re=new RegExp('^([ \\t]*)('+Object.keys(orders).join('|')+')\\s*(#\\s*\\([^;]*?\\)\\s*)?(\\w+)\\s*\\(','gm');
const outputs={};
for(const [file,src] of Object.entries(original)){
 let s=src;const insts=[...s.matchAll(re)];let count=0;
 for(const m of insts.reverse()){
  const start=m.index+m[0].length,end=close(s,start-1),body=s.slice(start,end);
  const lineRe=/^([ \t]*\.([A-Za-z_]\w*)[ \t]*\([^\r\n]*\))([ \t]*)(,?)([^\r\n]*)/gm;
  const rows=[...body.matchAll(lineRe)];if(!rows.length)continue;
  const order=orders[m[2]];
  if(rows.some(r=>!order.includes(r[2])))throw Error('Unknown port '+file+' '+m[4]);
  const sorted=[...rows].sort((a,b)=>order.indexOf(a[2])-order.indexOf(b[2]));
  if(sorted.every((r,i)=>r===rows[i]))continue;
  let updated=body;
  for(let i=rows.length-1;i>=0;i--){
   const target=rows[i],source=sorted[i];
   const line=source[1]+source[3]+(i===rows.length-1?'':',')+source[5];
   updated=updated.slice(0,target.index)+line+updated.slice(target.index+target[0].length);
  }
  // Only connection-line order and required comma placement may change.
  const stripCommas=t=>t.replace(/\)([ \t]*),/g,')$1');
  const before=body.split(/\r?\n/).map(stripCommas).sort();
  const after=updated.split(/\r?\n/).map(stripCommas).sort();
  if(JSON.stringify(before)!==JSON.stringify(after))throw Error('Whitespace or text changed: '+file);
  s=s.slice(0,start)+updated+s.slice(end);count++;
 }
 outputs[file]=s;
 console.log(file+': '+count+' connection lists reordered');
}
for(const file of files)if(fs.readFileSync(path.join(dir,file),'latin1')!==current[file])throw Error('Concurrent edit: '+file);
for(const file of files)fs.writeFileSync(path.join(dir,file),outputs[file],'latin1');
console.log('Restored original declarations, comments, indentation and whitespace in all 16 files.');
