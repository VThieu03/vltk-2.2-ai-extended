const {chromium} = require('C:/Users/nguye/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');
const assert = require('node:assert/strict');

(async () => {
  const browser = await chromium.launch({channel:'chrome',headless:true,args:['--enable-webgl','--use-angle=swiftshader']});
  const page = await browser.newPage({viewport:{width:800,height:700}});
  const errors = [];
  page.on('pageerror',error => errors.push(error.message));
  await page.goto('file:///D:/vltk-2.2-ai-extended/work/weapon-lightning-preview.html');
  const frame = page.frames().find(frame => frame !== page.mainFrame());
  await frame.waitForSelector('canvas[data-elapsed]');
  await page.waitForTimeout(1200);
  const inspect = () => frame.evaluate(() => {
    const canvas = document.querySelector('canvas');
    const gl = canvas.getContext('webgl2') || canvas.getContext('webgl');
    const pixels = new Uint8Array(canvas.width*canvas.height*4);
    gl.readPixels(0,0,canvas.width,canvas.height,gl.RGBA,gl.UNSIGNED_BYTE,pixels);
    let hash = 2166136261, painted = 0;
    for(let i=0;i<pixels.length;i++) hash = Math.imul(hash^pixels[i],16777619);
    for(let i=3;i<pixels.length;i+=4) if(pixels[i]>4) painted++;
    const shape = Array.from(canvas.dataset.shape || '').reduce((hash,char) => Math.imul(hash^char.charCodeAt(0),16777619),2166136261)>>>0;
    return {hash:hash>>>0,painted,elapsed:Number(canvas.dataset.elapsed),flames:Number(canvas.dataset.flames),shape,
      overflow:document.documentElement.scrollWidth>window.innerWidth,
      alert:!document.querySelector('[role="alert"]').hidden};
  });
  const base = await inspect();
  assert(base.painted>10000 && !base.alert && !base.overflow);
  assert(base.flames>20 && base.flames<=72);
  const hashes = [];
  for(const element of ['1','2','3','4','5']) {
    await frame.locator('[data-element]').selectOption(element);
    hashes.push((await inspect()).hash);
  }
  assert.equal(new Set(hashes).size,5);
  await frame.locator('[data-element]').selectOption('4');
  await page.screenshot({path:'D:/vltk-2.2-ai-extended/work/weapon-lightning-desktop.png',fullPage:true});
  await frame.locator('[data-glow]').uncheck();
  const off = await inspect();
  assert.notEqual(off.hash,base.hash);
  assert.equal(off.flames,0);
  await frame.locator('[data-glow]').check();
  await frame.locator('[data-play]').click();
  await page.waitForTimeout(350);
  const before = await inspect();
  await page.waitForTimeout(360);
  const after = await inspect();
  assert(after.elapsed>before.elapsed && after.hash!==before.hash);
  assert.notEqual(after.shape,before.shape);
  await page.screenshot({path:'D:/vltk-2.2-ai-extended/work/weapon-lightning-moving.png',fullPage:true});
  await frame.locator('[data-play]').click();
  await page.emulateMedia({colorScheme:'dark'});
  await page.screenshot({path:'D:/vltk-2.2-ai-extended/work/weapon-lightning-dark.png',fullPage:true});
  await page.setViewportSize({width:360,height:700});
  await page.emulateMedia({colorScheme:'light'});
  await page.waitForTimeout(200);
  const mobile = await inspect();
  assert(!mobile.overflow && mobile.painted>2500 && mobile.flames>20);
  await page.screenshot({path:'D:/vltk-2.2-ai-extended/work/weapon-lightning-mobile.png',fullPage:true});
  await frame.locator('[data-angle]').fill('-45');
  await frame.locator('[data-angle]').dispatchEvent('input');
  assert.notEqual((await inspect()).hash,mobile.hash);
  await page.emulateMedia({reducedMotion:'reduce'});
  await page.reload();
  const reducedFrame = page.frames().find(frame => frame !== page.mainFrame());
  await reducedFrame.waitForSelector('canvas[data-elapsed]');
  assert(await reducedFrame.locator('[data-play]').isDisabled());
  assert.deepEqual(errors,[]);
  console.log(JSON.stringify({desktop:base,colours:hashes,animation:[before,after],mobile,errors},null,2));
  await browser.close();
})().catch(error => {console.error(error);process.exitCode=1;});
