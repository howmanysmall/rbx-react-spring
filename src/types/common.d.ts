import type { EasingFunction } from "../constants";

export type AnimatableType =
	| number
	| CFrame
	| Color3
	| DateTime
	| NumberRange
	| NumberSequenceKeypoint
	| PhysicalProperties
	| Ray
	| Rect
	| Region3
	| Region3int16
	| UDim
	| UDim2
	| Vector2
	| Vector2int16
	| Vector3
	| Vector3int16;

type AnimationStyle = {
	[key: string]: AnimatableType;
};

export type AnimationProperties<T extends AnimationStyle> = {
	from?: T;
	to?: T;
};

export type SharedAnimationProperties = {
	config?: AnimationConfigs;
	default?: boolean;
	delay?: number;
	immediate?: boolean;
	loop?: boolean;
	reset?: boolean;
};

export interface AnimationConfigs {
	/**
	 * Higher mass means more friction is required to slow down.
	 * Defaults to 1, which works fine most of the time.
	 */
	mass?: number;

	/**
	 * With higher tension, the spring will resist bouncing and try harder to stop at its end value.
	 * When tension is zero, no animation occurs.
	 */
	tension?: number;

	/**
	 * The damping ratio coefficient.
	 * Higher friction means the spring will slow down faster.
	 */
	friction?: number;

	/**
	 * Avoid overshooting by ending abruptly at the goal value.
	 */
	clamp?: boolean;

	/**
	 * The smallest distance from a value before that distance is essentially zero.
	 *
	 * This helps in deciding when a spring is "at rest". The spring must be within
	 * this distance from its final value, and its velocity must be lower than this
	 * value too (unless `restVelocity` is defined).
	 */
	precision?: number;

	/**
	 * For `duration` animations only. Note: The `duration` is not affected
	 * by this property.
	 *
	 * Defaults to `0`, which means "start from the beginning".
	 *
	 * Setting to `1+` makes an immediate animation.
	 *
	 * Setting to `0.5` means "start from the middle of the easing function".
	 *
	 * Any number `>= 0` and `<= 1` makes sense here.
	 */
	progress?: number;

	/**
	 * The initial velocity of one or more values.
	 */
	velocity?: ReadonlyArray<number> | number;

	/**
	 * The animation curve. Only used when `duration` is defined.
	 */
	easing?: EasingFunction;

	/**
	 * The damping ratio, which dictates how the spring slows down.
	 *
	 * Set to `0` to never slow down. Set to `1` to slow down without bouncing.
	 * Between `0` and `1` is for you to explore.
	 *
	 * Only works when `frequency` is defined.
	 */
	damping?: number;

	/**
	 * Animation length in number of seconds.
	 */
	duration?: number;

	/**
	 * The natural frequency (in seconds), which dictates the number of bounces
	 * per second when no damping exists.
	 *
	 * When defined, `tension` is derived from this, and `friction` is derived
	 * from `tension` and `damping`.
	 */
	frequency?: number;

	/**
	 * When above zero, the spring will bounce instead of overshooting when
	 * exceeding its goal value. Its velocity is multiplied by `-1 + bounce`
	 * whenever its current value equals or exceeds its goal. For example,
	 * setting `bounce` to `0.5` chops the velocity in half on each bounce,
	 * in addition to any friction.
	 */
	bounce?: number;

	/**
	 * The smallest velocity before the animation is considered "not moving".
	 * When undefined, `precision` is used instead.
	 */
	restVelocity?: number;
}
