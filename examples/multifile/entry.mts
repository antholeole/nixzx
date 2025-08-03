import { callHello } from "./lib.mts";

const helloOutput = await callHello();
console.log(`hello from another file: ${helloOutput}`);
