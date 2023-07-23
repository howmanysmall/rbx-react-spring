/* eslint-disable unicorn/filename-case */
import { Binding } from "@rbxts/roact";
import { AnimationProperties, AnimationStyle, SharedAnimationProperties } from "./types/common";

export type ControllerProperties<T extends AnimationStyle> = (AnimationProperties<T> | T) & SharedAnimationProperties;

export interface ControllerApi {
	start(this: void, startProperties?: ControllerProperties<AnimationStyle>): Promise<void>;
	stop(this: void, keys?: [string]): Promise<void>;
	pause(this: void, keys?: [string]): Promise<void>;
}

declare interface Constructor {
	new <T extends AnimationStyle>(
		properties: ControllerProperties<T>,
	): LuaTuple<[{ [key in keyof T]: Binding<T[key]> }, ControllerApi]>;
}

declare const Controller: Constructor;
export default Controller;
