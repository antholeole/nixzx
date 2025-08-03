import { $ } from "zx";

export const callHello = async () => {
	const proc = await $`hello`;
	return `hello output: ${proc.stdout}`;
};
