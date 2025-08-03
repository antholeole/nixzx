import { $ } from "zx";

const proc = await $`hello`;
console.log(`hello output: ${proc.stdout}`);
