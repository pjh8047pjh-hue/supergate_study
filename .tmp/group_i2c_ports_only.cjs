const fs = require('fs');
const path = require('path');
const root = 'C:/Work/assignment_6/i2c_rx_assignment/design';
const backup = 'C:/Work/.tmp/i2c_port_order_before';
const desired = {
  ass_i2c_slave_serdes: 'clk rstb scl sda rx_full tx_empty tx_rdata_in ack_out_req start stop_nack req rx_wen rx_wdata tx_ren sda_oe',
  ass_i2c_slave_serdes_fsm: 'clk rstb start stop scl_rise scl_fall ack_bit cnt_scl rx_full rx_wdata tx_empty tx_rdata ack_req_sync ack_start_sync ack_stop_sync init_0 cnt_inc cnt_max rx_en rx_wen tx_ren stop_nack req sda_oe',
  ass_i2c_slave_pkg_dec: 'clk rstb start stop_nack req rx_empty rx_rdata tx_full rdata ack_out_req rx_ren tx_wen tx_wdata we addr wdata',
  ass_i2c_slave_pkg_dec_fsm: 'clk rstb start stop_nack req rx_empty tx_full rx_ren tx_wen waddr_en addr_inc we',
  edge_detecter: 'clk rstb scl sda start stop scl_rise scl_fall scl_d2 sda_rise sda_fall sda_d2',
};
function walk(d) { return fs.readdirSync(d,{withFileTypes:true}).flatMap(e=>e.isDirectory()?walk(path.join(d,e.name)):e.name.endsWith('.v')?[path.join(d,e.name)]:[]); }
const files = [...walk(path.join(root,'rtl')), ...walk(path.join(root,'tb'))];
const before = Object.fromEntries(files.map(f=>[f,fs.readFileSync(f,'latin1')]));
const after = {...before};
const orders = {};
function closing(s,start) { let depth=0;for(let i=start;i<s.length;i++){if(s[i]==='(')depth++;else if(s[i]===')'&&--depth===0)return i;}throw Error('Unbalanced parentheses'); }
function header(s) { const m=/\bmodule\s+(\w+)\s*/.exec(s);let start=m.index+m[0].length;if(s[start]==='#'){start=closing(s,s.indexOf('(',start))+1;while(/\s/.test(s[start]))start++;}return {name:m[1],start,end:closing(s,start)}; }
function orderRows(body,rows,ordered) {
  let result=body;
  for(let i=rows.length-1;i>=0;i--){const target=rows[i],source=ordered[i];const line=source[1]+(i===rows.length-1?'':',')+source[3];result=result.slice(0,target.index)+line+result.slice(target.index+target[0].length);}
  return result;
}
for(const [file,src] of Object.entries(before)) {
  if(!file.includes(path.sep+'rtl'+path.sep))continue;
  const h=header(src),body=src.slice(h.start+1,h.end);
  orders[h.name]=body.replace(/\/\/[^\r\n]*/g,'').split(',').map(s=>s.trim().match(/\w+$/)[0]);
  if(!desired[h.name])continue;
  const rows=[...body.matchAll(/^([ \t]*(?:input|output|inout)\b[^,\r\n]*?\b\w+)(,?)([ \t]*(?:\/\/[^\r\n]*)?)(?=\r?$)/gm)];
  const name=r=>r[1].match(/\w+$/)[0];
  const byName=new Map(rows.map(r=>[name(r),r]));
  const names=desired[h.name].split(' ');
  if(names.length!==rows.length||names.some(n=>!byName.has(n)))throw Error('Port coverage '+file);
  const sorted=names.map(n=>byName.get(n));
  if(rows.some((r,i)=>r[1].match(/\b(input|output|inout)\b/)[1]!==sorted[i][1].match(/\b(input|output|inout)\b/)[1]))throw Error('Port direction order changed '+file);
  after[file]=src.slice(0,h.start+1)+orderRows(body,rows,sorted)+src.slice(h.end);
  orders[h.name]=names;
}
const instanceRE=new RegExp('^([ \\t]*)('+Object.keys(orders).join('|')+')\\s*(#\\s*\\([^;]*?\\)\\s*)?(\\w+)\\s*\\(','gm');
for(const file of files){
 let s=after[file];
 for(const m of [...s.matchAll(instanceRE)].reverse()){
  const start=m.index+m[0].length,end=closing(s,start-1),body=s.slice(start,end);
  const rows=[...body.matchAll(/^([ \t]*\.\w+[ \t]*\([^\r\n]*\))([,]?)([^\r\n]*)/gm)];
  if(!rows.length){if(desired[m[2]])throw Error('Positional instance needs review '+file);continue;}
  const name=r=>r[1].match(/\.([A-Za-z_]\w*)/)[1];
  if(rows.some(r=>!orders[m[2]].includes(name(r))))throw Error('Unknown port '+file+' '+m[4]);
  const sorted=[...rows].sort((a,b)=>orders[m[2]].indexOf(name(a))-orders[m[2]].indexOf(name(b)));
  if(sorted.every((r,i)=>r===rows[i]))continue;
  s=s.slice(0,start)+orderRows(body,rows,sorted)+s.slice(end);
 }
 after[file]=s;
}
// A line can only move, with its comma adjusted to its new position.
function lineInventory(s){return s.split(/\r?\n/).map(l=>l.replace(/,([ \t]*(?:\/\/.*)?)$/,'$1')).sort();}
function skeleton(s){const h=header(s);s=s.slice(0,h.start+1)+'<ports>'+s.slice(h.end);for(const m of [...s.matchAll(instanceRE)].reverse()){const start=m.index+m[0].length,end=closing(s,start-1);s=s.slice(0,start)+'<connections>'+s.slice(end);}return s;}
for(const file of files){
 if(JSON.stringify(lineInventory(before[file]))!==JSON.stringify(lineInventory(after[file])))throw Error('Whitespace/comment/text change '+file);
 if(skeleton(before[file])!==skeleton(after[file]))throw Error('Non-port change '+file);
 if(fs.readFileSync(file,'latin1')!==before[file])throw Error('Concurrent edit '+file);
}
for(const file of files){if(before[file]===after[file])continue;const dest=path.join(backup,path.relative(root,file));fs.mkdirSync(path.dirname(dest),{recursive:true});if(fs.existsSync(dest))throw Error('Backup exists '+dest);fs.writeFileSync(dest,before[file],'latin1');fs.writeFileSync(file,after[file],'latin1');console.log('Reordered '+path.relative(root,file));}
console.log('Verified: directions, comments, whitespace, expressions and connection values preserved.');
