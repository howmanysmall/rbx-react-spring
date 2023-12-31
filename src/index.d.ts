import { Config, EasingDictionary, createBezier } from "./constants";
export type { AnimationConfigs } from "./types/common";
export type { ControllerProperties } from "./Controller";

export const configs: Config;
export const createBezier: createBezier;
export const easings: EasingDictionary;

export { default as Controller } from "./Controller";
export { default as useSprings } from "./hooks/useSprings";
export { default as useSpring } from "./hooks/useSpring";

export { default as useTrail } from "./hooks/useTrail";
