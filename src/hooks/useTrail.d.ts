/* eslint-disable unicorn/filename-case */
import { Binding } from "@rbxts/roact";
import { AnimationStyle } from "../types/common";
import { ControllerProperties } from "../Controller";
import { UseSpringsApi } from "./useSprings";

declare interface UseTrail {
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

declare const useTrail: UseTrail;
export default useTrail;
