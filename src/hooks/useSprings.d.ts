/* eslint-disable unicorn/filename-case */
import { AnimationStyle } from "../types/common";
import { Binding } from "@rbxts/roact";
import { ControllerProperties } from "../Controller";

export type UseSpringsApi<T extends AnimationStyle> = {
	start(this: void, callback?: (index: number) => ControllerProperties<T>): Promise<void>;
	stop(this: void, keys?: [string]): Promise<void>;
	pause(this: void, keys?: [string]): Promise<void>;
};

declare interface UseSprings {
	<T extends AnimationStyle, E extends ControllerProperties<T>>(
		length: number,
		properties: Array<E>,
		dependencies?: ReadonlyArray<unknown>,
	): ReadonlyArray<{
		[key in keyof E]: Binding<E[key]>;
	}>;

	// todo: this needs to be fixed
	<T extends AnimationStyle, E extends ControllerProperties<T>>(
		length: number,
		properties: (index: number) => E,
		dependencies?: ReadonlyArray<unknown>,
	): LuaTuple<[ReadonlyArray<{ [key in keyof E]: Binding<E[key]> }>, UseSpringsApi<T>]>;
}

declare const useSprings: UseSprings;
export default useSprings;
