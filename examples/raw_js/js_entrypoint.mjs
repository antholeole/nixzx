import { $ } from "zx";

const proc = await $`hello`;
console.log(`hello proc from js: ${proc.stdout}`);

