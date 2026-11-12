const fs = require('node:fs');
const vm = require('node:vm');
const assert = require('node:assert/strict');

const fragmentPath = 'C:/Users/JH/.codex/visualizations/2026/11/05/01a1aabe-ff61-76f2-a520-d7db700c426c/i2c-cdc-state-timing.html';
const fragment = fs.readFileSync(fragmentPath, 'utf8');
const script = fragment.match(/<script>([\s\S]*?)<\/script>/)[1];
new vm.Script(script);

for (const viewportWidth of [280, 320, 480, 736, 1024]) {
  class MockElement {
    constructor(tag = 'div') {
      this.tag = tag;
      this.children = [];
      this.attributes = {};
      this.listeners = {};
      this.value = '';
      this.textContent = '';
    }
    setAttribute(key, value) { this.attributes[key] = value; }
    append(child) { this.children.push(child); }
    replaceChildren(...children) { this.children = children; }
    addEventListener(name, listener) { this.listeners[name] = listener; }
    getBoundingClientRect() { return { width: viewportWidth }; }
  }
  const roles = {};
  const root = new MockElement();
  root.querySelector = selector => {
    const name = selector.match(/data-role="([^"]+)"/)[1];
    roles[name] ||= new MockElement();
    return roles[name];
  };
  const context = {
    document: {
      getElementById: () => root,
      createElementNS: (namespace, tag) => new MockElement(tag)
    },
    window: { openai: { setWidgetState: () => Promise.resolve() } },
    ResizeObserver: class { observe() {} }
  };
  vm.runInNewContext(script, context);
  for (const mode of ['write', 'read', 'cdc']) {
    roles.mode.value = mode;
    roles.mode.listeners.change();
    const last = Number(roles.step.max);
    for (let step = 0; step <= last; step++) {
      roles.step.value = String(step);
      roles.step.listeners.input();
      assert(roles.detail.textContent.length > 0);
      const svg = roles.chart.children[0];
      assert.equal(svg.tag, 'svg');
      const walk = node => {
        for (const value of Object.values(node.attributes)) {
          assert(!/NaN|undefined|Infinity/.test(value));
        }
        if (node.tag === 'text') {
          assert(Number(node.attributes.x) >= 0);
          assert(Number(node.attributes.x) <= viewportWidth);
        }
        node.children.forEach(walk);
      };
      walk(svg);
    }
    roles.previous.listeners.click();
    assert(roles.position.textContent.startsWith(String(last) + ' /'));
    roles.next.listeners.click();
    assert.equal(roles.next.disabled, true);
  }
}
assert(!fragment.includes('\\"'));
assert(!fragment.includes('\\n'));
console.log('Verified syntax, all steps and controls at 5 widths.');
