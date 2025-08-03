import { $ } from "zx";

export const callHello = async (): Promise<string> => {
	const proc = await $`hello`;
	return `hello output: ${proc.stdout}`;
};
