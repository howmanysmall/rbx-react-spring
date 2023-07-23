/* eslint-disable unicorn/filename-case */
import { AnimationStyle } from "../types/common";
import { Binding } from "@rbxts/roact";
import { ControllerApi, ControllerProperties } from "../Controller";

declare interface UseSpring {
	<T extends ControllerProperties<AnimationStyle>>(
		properties: T,
		dependencies?: ReadonlyArray<unknown>,
	): {
		[key in keyof T]: Binding<T[key]>;
	};

	<T extends ControllerProperties<AnimationStyle>>(
		properties: () => T,
		dependencies?: ReadonlyArray<unknown>,
	): LuaTuple<[{ [key in keyof T]: Binding<T[key]> }, ControllerApi]>;
}

declare const useSpring: UseSpring;
export default useSpring;
