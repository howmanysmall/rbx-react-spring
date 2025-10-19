import type { Binding } from "@rbxts/react";

type AnimationStyle = Record<string, ReactSpring.AnimatableType>;

// biome-ignore lint/complexity/noBannedTypes: exceedingly unhelpful
type EnforceProperties<P> = (P extends { from?: infer F } ? { from?: AnimationStyle & F } : {}) &
	// enforce from/to (when present) are AnimationStyle
	// biome-ignore lint/complexity/noBannedTypes: exceedingly unhelpful
	(P extends { to?: infer T2 } ? { to?: AnimationStyle & T2 } : {}) &
	// enforce direct style keys on the root object
	{
		[K in keyof StripNonStyle<P>]: StripNonStyle<P>[K] extends ReactSpring.AnimatableType
			? StripNonStyle<P>[K]
			: never;
	};
type ExtractStyle<P> = P extends { from?: infer F }
	? F extends AnimationStyle
		? F
		: never
	: P extends { to?: infer T2 }
		? T2 extends AnimationStyle
			? T2
			: never
		: {
				[K in keyof StripNonStyle<P> as StripNonStyle<P>[K] extends ReactSpring.AnimatableType
					? K
					: never]: StripNonStyle<P>[K];
			};

type NonStyleKeys = "from" | "to" | keyof ReactSpring.SharedAnimationProperties;

type StripNonStyle<T> = { [K in keyof T as K extends NonStyleKeys ? never : K]: T[K] };

/**
 * Function signature interface for the useSpring hook with multiple overloads.
 *
 * This interface defines the two main usage patterns for useSpring: declarative
 * (with direct properties) and imperative (with factory functions). The hook
 * automatically detects which pattern you're using based on whether you pass a
 * function or object.
 *
 * **Overload 1: Declarative Pattern**.
 *
 * - Pass animation properties directly
 * - Returns only the animated styles
 * - Updates automatically on re-render.
 *
 * **Overload 2: Imperative Pattern**.
 *
 * - Pass a factory function returning properties
 * - Returns both styles and API for manual control
 * - Requires explicit API calls to update.
 *
 * @see {@link https://www.chrisc.dev/roact-spring/docs/Hooks/useSpring | useSpring Guide}
 */
interface UseSpring {
	<F extends () => ReactSpring.ControllerProperties<AnimationStyle>>(
		properties: F,
		dependencies?: ReadonlyArray<unknown>,
	): LuaTuple<
		[
			{ readonly [K in keyof ExtractStyle<ReturnType<F>>]: Binding<ExtractStyle<ReturnType<F>>[K]> },
			ReactSpring.ControllerApi,
		]
	>;

	<P extends ReactSpring.ControllerProperties<AnimationStyle>>(
		properties: EnforceProperties<P> & P,
		dependencies?: ReadonlyArray<unknown>,
	): { readonly [K in keyof ExtractStyle<P>]: Binding<ExtractStyle<P>[K]> };
}
/**
 * Function signature interface for the useSprings hook with multiple overloads.
 *
 * This interface defines the two main usage patterns for useSprings:
 * declarative (with property arrays) and imperative (with factory functions).
 * The hook creates multiple springs simultaneously, each with potentially
 * different properties and timing.
 *
 * **Overload 1: Declarative Pattern**.
 *
 * - Pass length and array of animation properties
 * - Returns array of animated styles
 * - Updates automatically on re-render.
 *
 * **Overload 2: Imperative Pattern**.
 *
 * - Pass length and factory function returning properties per index
 * - Returns both styles array and API for manual control
 * - Requires explicit API calls to update.
 *
 * @see {@link https://www.chrisc.dev/roact-spring/docs/Hooks/useSprings | useSprings Guide}
 */
interface UseSprings {
	<F extends (index: number) => ReactSpring.ControllerProperties<AnimationStyle>>(
		length: number,
		properties: F,
		dependencies?: ReadonlyArray<unknown>,
	): LuaTuple<
		[
			ReadonlyArray<{
				readonly [K in keyof ExtractStyle<ReturnType<F>>]: Binding<ExtractStyle<ReturnType<F>>[K]>;
			}>,
			ReactSpring.UseSpringsApi<ExtractStyle<ReturnType<F>>>,
		]
	>;

	<P extends ReactSpring.ControllerProperties<AnimationStyle>>(
		length: number,
		properties: ReadonlyArray<EnforceProperties<P> & P>,
		dependencies?: ReadonlyArray<unknown>,
	): ReadonlyArray<{ readonly [K in keyof ExtractStyle<P>]: Binding<ExtractStyle<P>[K]> }>;
}

/**
 * Function signature interface for the useTrail hook with multiple overloads.
 *
 * This interface defines the two main usage patterns for useTrail: declarative
 * (with property arrays) and imperative (with factory functions). The hook
 * creates staggered springs where each follows the previous one with automatic
 * delay timing.
 *
 * **Overload 1: Declarative Pattern**.
 *
 * - Pass length and array of animation properties
 * - Returns array of animated styles with automatic staggering
 * - Updates automatically on re-render.
 *
 * **Overload 2: Imperative Pattern**.
 *
 * - Pass length and factory function returning properties per index
 * - Returns both styles array and API for manual control
 * - Requires explicit API calls to update.
 *
 * **Key Feature:** Unlike useSprings, useTrail automatically staggers the
 * animations so each spring follows the previous one with a default delay.
 *
 * @see {@link https://www.chrisc.dev/roact-spring/docs/Hooks/useTrail | useTrail Guide}
 */
interface UseTrail {
	/**
	 * Creates a trailing animation using a property factory.
	 *
	 * @param length - Number of trail segments to produce.
	 * @param properties - Factory returning spring properties per index.
	 * @param dependencies - Optional change list for memoization.
	 * @returns Bindings and the shared trail API.
	 */
	<F extends (index: number) => ReactSpring.ControllerProperties<AnimationStyle>>(
		length: number,
		properties: F,
		dependencies?: ReadonlyArray<unknown>,
	): LuaTuple<
		[
			ReadonlyArray<{
				readonly [K in keyof ExtractStyle<ReturnType<F>>]: Binding<ExtractStyle<ReturnType<F>>[K]>;
			}>,
			ReactSpring.UseSpringsApi<ExtractStyle<ReturnType<F>>>,
		]
	>;

	<P extends ReactSpring.ControllerProperties<AnimationStyle>>(
		length: number,
		properties: ReadonlyArray<EnforceProperties<P> & P>,
		dependencies?: ReadonlyArray<unknown>,
	): ReadonlyArray<{ readonly [K in keyof ExtractStyle<P>]: Binding<ExtractStyle<P>[K]> }>;
}

declare namespace ReactSpring {
	/**
	 * Union type of all Roblox data types that can be animated by react-spring.
	 *
	 * React-spring supports interpolation between values of these types,
	 * enabling smooth animations for UI properties, 3D transformations, colors,
	 * and more. Each type has specialized interpolation logic to create
	 * natural-feeling animations.
	 *
	 * @example
	 *
	 * ```typescript
	 * // Animating different property types
	 * const styles = useSpring({
	 * 	from: {
	 * 		position: UDim2.fromScale(0, 0), // UDim2
	 * 		transparency: 1, // number
	 * 		color: Color3.fromRGB(255, 0, 0), // Color3
	 * 		cframe: new CFrame(), // CFrame
	 * 		size: Vector2.new(100, 100), // Vector2
	 * 	},
	 * 	to: {
	 * 		position: UDim2.fromScale(1, 1),
	 * 		transparency: 0,
	 * 		color: Color3.fromRGB(0, 255, 0),
	 * 		cframe: CFrame.Angles(0, math.rad(90), 0),
	 * 		size: Vector2.new(200, 200),
	 * 	},
	 * });
	 * ```
	 *
	 * @see {@link https://www.chrisc.dev/roact-spring/docs/Getting%20Started | Getting Started Guide}
	 */
	export type AnimatableType =
		| CFrame
		| Color3
		| DateTime
		| number
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

	/**
	 * Comprehensive configuration options for customizing spring animation
	 * behavior.
	 *
	 * This interface provides fine-grained control over spring physics, timing,
	 * and animation characteristics. You can choose between physics-based
	 * spring animations (using mass, tension, friction) or time-based
	 * animations (using duration and easing functions).
	 *
	 * **Spring Physics Properties:**.
	 *
	 * - `mass`, `tension`, `friction` - Control spring behavior
	 * - `bounce`, `frequency`, `damping` - Alternative spring controls
	 * - `clamp`, `precision`, `restVelocity` - Fine-tune animation ending.
	 *
	 * **Time-based Properties:**.
	 *
	 * - `duration`, `easing` - Create time-based animations instead of
	 *   physics-based - `progress` - Control animation start position.
	 *
	 * **Control Properties:**.
	 *
	 * - `velocity` - Set initial animation velocity.
	 *
	 * @example
	 *
	 * ```typescript
	 * // Physics-based spring
	 * const bouncy = {
	 * 	mass: 1,
	 * 	tension: 180,
	 * 	friction: 12,
	 * 	clamp: false,
	 * };
	 *
	 * // Time-based animation
	 * const timed = {
	 * 	duration: 1000,
	 * 	easing: ReactSpring.easings.easeOutBounce,
	 * };
	 *
	 * // Frequency-based spring
	 * const frequencyBased = {
	 * 	frequency: 0.8,
	 * 	damping: 0.7,
	 * };
	 * ```
	 *
	 * @see {@link https://www.chrisc.dev/roact-spring/docs/Common/configs | Configuration Guide}
	 */
	export interface AnimationConfiguration {
		/**
		 * When above zero, the spring will bounce instead of overshooting when
		 * exceeding its goal value. Its velocity is multiplied by `-1.
		 *
		 * - Bounce`whenever its current value equals or exceeds its goal. For
		 *   example, setting`bounce`to`0.5` chops the velocity in half on each
		 *   bounce, in addition to any friction.
		 */
		readonly bounce?: number;

		/** Avoid overshooting by ending abruptly at the goal value. */
		readonly clamp?: boolean;

		/**
		 * The damping ratio, which dictates how the spring slows down.
		 *
		 * Set to `0` to never slow down. Set to `1` to slow down without
		 * bouncing. Between `0` and `1` is for you to explore.
		 *
		 * Only works when `frequency` is defined.
		 */
		readonly damping?: number;

		/** Animation length in number of seconds. */
		readonly duration?: number;

		/** The animation curve. Only used when `duration` is defined. */
		readonly easing?: EasingFunction;

		/**
		 * The natural frequency (in seconds), which dictates the number of
		 * bounces per second when no damping exists.
		 *
		 * When defined, `tension` is derived from this, and `friction` is
		 * derived from `tension` and `damping`.
		 */
		readonly frequency?: number;

		/**
		 * The damping ratio coefficient. Higher friction means the spring will
		 * slow down faster.
		 */
		readonly friction?: number;

		/**
		 * Higher mass means more friction is required to slow down. Defaults to
		 * 1, which works fine most of the time.
		 */
		readonly mass?: number;

		/**
		 * The smallest distance from a value before that distance is
		 * essentially zero.
		 *
		 * This helps in deciding when a spring is "at rest". The spring must be
		 * within this distance from its final value, and its velocity must be
		 * lower than this value too (unless `restVelocity` is defined).
		 */
		readonly precision?: number;

		/**
		 * For `duration` animations only. Note: The `duration` is not affected
		 * by this property.
		 *
		 * Defaults to `0`, which means "start from the beginning".
		 *
		 * Setting to `1+` makes an immediate animation.
		 *
		 * Setting to `0.5` means "start from the middle of the easing
		 * function".
		 *
		 * Any number `>= 0` and `<= 1` makes sense here.
		 */
		readonly progress?: number;

		/**
		 * The smallest velocity before the animation is considered "not
		 * moving". When undefined, `precision` is used instead.
		 */
		readonly restVelocity?: number;

		/**
		 * With higher tension, the spring will resist bouncing and try harder
		 * to stop at its end value. When tension is zero, no animation occurs.
		 */
		readonly tension?: number;

		/** The initial velocity of one or more values. */
		readonly velocity?: number | ReadonlyArray<number>;
	}

	/**
	 * Core animation properties that define the start and end states of an
	 * animation.
	 *
	 * This interface provides the fundamental `from` and `to` properties that
	 * specify where an animation begins and where it should end. These
	 * properties form the foundation of all spring animations in react-spring.
	 *
	 * @example
	 *
	 * ```typescript
	 * // Basic from/to animation
	 * const fadeIn: AnimationProperties<{ transparency: number }> = {
	 * 	from: { transparency: 1 },
	 * 	to: { transparency: 0 },
	 * };
	 *
	 * // Position animation
	 * const slideIn: AnimationProperties<{ position: UDim2 }> = {
	 * 	from: { position: UDim2.fromScale(-1, 0) },
	 * 	to: { position: UDim2.fromScale(0, 0) },
	 * };
	 * ```
	 *
	 * @template T - The animation style type extending AnimationStyle.
	 * @see {@link https://www.chrisc.dev/roact-spring/docs/Common/props | Animation Properties Guide}
	 */
	export interface AnimationProperties<T extends AnimationStyle> {
		readonly from?: T;
		readonly to?: T;
	}

	/**
	 * A function that defines the progression of an animation over time.
	 *
	 * Easing functions control how animations accelerate and decelerate,
	 * creating different visual effects like smooth transitions, bouncing, or
	 * elastic movements. They map a linear time progression (0 to 1) to a
	 * potentially non-linear animation progression.
	 *
	 * @example
	 *
	 * ```typescript
	 * // Custom easing function
	 * const customEasing: EasingFunction = (alpha) => alpha * alpha; // Quadratic ease-in
	 *
	 * // Using with animation config
	 * const styles = useSpring({
	 * 	to: { transparency: 0 },
	 * 	config: { easing: customEasing, duration: 1 },
	 * });
	 * ```
	 *
	 * @param alpha - The linear time progression from 0 (start) to 1 (end).
	 * @returns The eased progression value, typically between 0 and 1.
	 * @see {@link https://www.chrisc.dev/roact-spring/docs/Common/configs | Configuration Guide}
	 */
	export type EasingFunction = (alpha: number) => number;

	/**
	 * Common animation properties shared across all spring animations.
	 *
	 * These properties control the behavior and timing of animations, providing
	 * fine-grained control over how animations execute, when they start, and
	 * how they repeat. They can be applied to any animation regardless of the
	 * specific style properties being animated.
	 *
	 * @example
	 *
	 * ```typescript
	 * // Using shared properties
	 * const styles = useSpring({
	 * 	to: { transparency: 0 },
	 * 	config: ReactSpring.config.wobbly, // Spring configuration
	 * 	delay: 500, // Wait 500ms before starting
	 * 	immediate: false, // Animate (don't jump)
	 * 	loop: true, // Repeat animation
	 * 	reset: true, // Start from initial values
	 * 	default: true, // Use as default for all props
	 * });
	 * ```
	 *
	 * @see {@link https://www.chrisc.dev/roact-spring/docs/Common/props | Animation Properties Guide}
	 * @see {@link https://www.chrisc.dev/roact-spring/docs/Common/configs | Configuration Guide}
	 */
	export interface SharedAnimationProperties {
		readonly config?: AnimationConfiguration;
		readonly default?: boolean;
		readonly delay?: number;
		readonly immediate?: boolean;
		readonly loop?: boolean;
		readonly reset?: boolean;
	}

	/**
	 * Pre-configured animation presets for common spring behaviors.
	 *
	 * These presets provide carefully tuned spring configurations for different
	 * animation styles, from gentle and slow movements to bouncy and energetic
	 * animations. Use these as starting points or combine them with custom
	 * properties for fine-tuned control.
	 *
	 * **Available Presets:**.
	 *
	 * - `default` - Balanced spring suitable for most UI animations
	 * - `gentle` - Soft, smooth animations with minimal overshoot
	 * - `wobbly` - Bouncy, playful animations with noticeable overshoot
	 * - `stiff` - Quick, sharp animations that settle rapidly
	 * - `slow` - Extended duration animations for emphasis
	 * - `molasses` - Very slow, deliberate animations
	 * - `snappy` - Fast, responsive animations.
	 *
	 * @example
	 *
	 * ```typescript
	 * // Using preset configurations
	 * const styles = useSpring({
	 * 	to: { scale: 1.2 },
	 * 	config: ReactSpring.config.wobbly, // Bouncy animation
	 * });
	 *
	 * // Combining with custom properties
	 * const customConfig = {
	 * 	...ReactSpring.config.stiff,
	 * 	mass: 2, // Override mass while keeping other stiff properties
	 * };
	 * ```
	 *
	 * @see {@link https://www.chrisc.dev/roact-spring/docs/Common/configs | Configuration Guide}
	 */
	export const config: {
		readonly default: AnimationConfiguration;
		readonly gentle: AnimationConfiguration;
		readonly molasses: AnimationConfiguration;
		readonly slow: AnimationConfiguration;
		readonly snappy: AnimationConfiguration;
		readonly stiff: AnimationConfiguration;
		readonly wobbly: AnimationConfiguration;
	};

	/**
	 * Creates a custom cubic bezier easing function using control points.
	 *
	 * This function allows you to create sophisticated custom easing curves by
	 * defining two control points that shape the bezier curve. The resulting
	 * function can be used in animation configurations to achieve precise
	 * timing and feel.
	 *
	 * Control points define the curve's shape:
	 *
	 * - (0,0) is the start point (implicit)
	 * - (x1,y1) is the first control point
	 * - (x2,y2) is the second control point
	 * - (1,1) is the end point (implicit).
	 *
	 * @example
	 *
	 * ```typescript
	 * // CSS ease-in-out equivalent
	 * const easeInOut = ReactSpring.createBezier(0.42, 0, 0.58, 1);
	 *
	 * // Custom bounce effect
	 * const customBounce = ReactSpring.createBezier(0.68, -0.6, 0.32, 1.6);
	 *
	 * // Using in animation
	 * const styles = useSpring({
	 * 	to: { transparency: 0 },
	 * 	config: {
	 * 		duration: 1000,
	 * 		easing: customBounce,
	 * 	},
	 * });
	 * ```
	 *
	 * @param x1 - X coordinate of first control point (0-1).
	 * @param y1 - Y coordinate of first control point (can exceed 0-1 for
	 *   overshoot).
	 * @param x2 - X coordinate of second control point (0-1).
	 * @param y2 - Y coordinate of second control point (can exceed 0-1 for
	 *   overshoot).
	 * @returns An easing function that can be used in animation configs.
	 * @see {@link https://cubic-bezier.com | Cubic Bezier Visualizer}
	 * @see {@link https://www.chrisc.dev/roact-spring/docs/Common/configs | Configuration Guide}
	 */
	export function createBezier(x1: number, y1: number, x2: number, y2: number): EasingFunction;

	/**
	 * Comprehensive collection of pre-built easing functions for animations.
	 *
	 * This namespace contains over 100 easing functions covering various
	 * animation styles from subtle UI transitions to dramatic effects. All
	 * functions follow standard easing patterns with "In", "Out", "InOut", and
	 * "OutIn" variants where applicable.
	 *
	 * **Easing Categories:**.
	 *
	 * - **Basic**: Quad, Cubic, Quart, Quint, Sine
	 * - **Advanced**: Back, Bounce, Circular, Elastic, Exponential
	 * - **Smooth**: Smooth, Smoother, SoftSpring, Spring
	 * - **Platform-specific**: Fabric, Mozilla, UWP, Standard
	 * - **Expressive**: Entrance, Exit, Acceleration, Deceleration
	 * - **Special**: RidiculousWiggle, RevBack, Sharp.
	 *
	 * **Easing Variants:**.
	 *
	 * - `easeIn*` - Slow start, fast finish
	 * - `easeOut*` - Fast start, slow finish
	 * - `easeInOut*` - Slow start and finish, fast middle
	 * - `easeOutIn*` - Fast start and finish, slow middle.
	 *
	 * @example
	 *
	 * ```typescript
	 * // Using different easing styles
	 * const bounceIn = useSpring({
	 * 	to: { scale: 1.2 },
	 * 	config: {
	 * 		duration: 800,
	 * 		easing: ReactSpring.easings.easeInBounce,
	 * 	},
	 * });
	 *
	 * const smoothOut = useSpring({
	 * 	to: { transparency: 0 },
	 * 	config: {
	 * 		duration: 500,
	 * 		easing: ReactSpring.easings.easeOutSmooth,
	 * 	},
	 * });
	 *
	 * // Platform-specific easings
	 * const fabricStandard = ReactSpring.easings.easeInOutFabricStandard;
	 * ```
	 *
	 * @see {@link https://easings.net | Easing Functions Visualizer}
	 * @see {@link https://www.chrisc.dev/roact-spring/docs/Common/configs | Configuration Guide}
	 */
	export namespace easings {
		export const easeInAcceleration: EasingFunction;
		export const easeInBack: EasingFunction;
		export const easeInBounce: EasingFunction;
		export const easeInCirc: EasingFunction;
		export const easeInCubic: EasingFunction;
		export const easeInDeceleration: EasingFunction;
		export const easeInElastic: EasingFunction;
		export const easeInEntranceExpressive: EasingFunction;
		export const easeInEntranceProductive: EasingFunction;
		export const easeInExitExpressive: EasingFunction;
		export const easeInExitProductive: EasingFunction;
		export const easeInExpo: EasingFunction;
		export const easeInFabricAccelerate: EasingFunction;
		export const easeInFabricDecelerate: EasingFunction;
		export const easeInFabricStandard: EasingFunction;
		export const easeInMozillaCurve: EasingFunction;
		export const easeInOutAcceleration: EasingFunction;
		export const easeInOutBack: EasingFunction;
		export const easeInOutBounce: EasingFunction;
		export const easeInOutCirc: EasingFunction;
		export const easeInOutCubic: EasingFunction;
		export const easeInOutDeceleration: EasingFunction;
		export const easeInOutElastic: EasingFunction;
		export const easeInOutEntranceExpressive: EasingFunction;
		export const easeInOutEntranceProductive: EasingFunction;
		export const easeInOutExitExpressive: EasingFunction;
		export const easeInOutExitProductive: EasingFunction;
		export const easeInOutExpo: EasingFunction;
		export const easeInOutFabricAccelerate: EasingFunction;
		export const easeInOutFabricDecelerate: EasingFunction;
		export const easeInOutFabricStandard: EasingFunction;
		export const easeInOutMozillaCurve: EasingFunction;
		export const easeInOutQuad: EasingFunction;
		export const easeInOutQuart: EasingFunction;
		export const easeInOutQuint: EasingFunction;
		export const easeInOutRevBack: EasingFunction;
		export const easeInOutRidiculousWiggle: EasingFunction;
		export const easeInOutSharp: EasingFunction;
		export const easeInOutSine: EasingFunction;
		export const easeInOutSmooth: EasingFunction;
		export const easeInOutSmoother: EasingFunction;
		export const easeInOutSoftSpring: EasingFunction;
		export const easeInOutSpring: EasingFunction;
		export const easeInOutStandard: EasingFunction;
		export const easeInOutStandardExpressive: EasingFunction;
		export const easeInOutStandardProductive: EasingFunction;
		export const easeInOutUWPAccelerate: EasingFunction;
		export const easeInQuad: EasingFunction;
		export const easeInQuart: EasingFunction;
		export const easeInQuint: EasingFunction;
		export const easeInRevBack: EasingFunction;
		export const easeInRidiculousWiggle: EasingFunction;
		export const easeInSharp: EasingFunction;
		export const easeInSine: EasingFunction;
		export const easeInSmooth: EasingFunction;
		export const easeInSmoother: EasingFunction;
		export const easeInSoftSpring: EasingFunction;
		export const easeInSpring: EasingFunction;
		export const easeInStandard: EasingFunction;
		export const easeInStandardExpressive: EasingFunction;
		export const easeInStandardProductive: EasingFunction;
		export const easeInUWPAccelerate: EasingFunction;
		export const easeOutAcceleration: EasingFunction;
		export const easeOutBack: EasingFunction;
		export const easeOutBounce: EasingFunction;
		export const easeOutCirc: EasingFunction;
		export const easeOutCubic: EasingFunction;
		export const easeOutDeceleration: EasingFunction;
		export const easeOutElastic: EasingFunction;
		export const easeOutEntranceExpressive: EasingFunction;
		export const easeOutEntranceProductive: EasingFunction;
		export const easeOutExitExpressive: EasingFunction;
		export const easeOutExitProductive: EasingFunction;
		export const easeOutExpo: EasingFunction;
		export const easeOutFabricAccelerate: EasingFunction;
		export const easeOutFabricDecelerate: EasingFunction;
		export const easeOutFabricStandard: EasingFunction;
		export const easeOutInAcceleration: EasingFunction;
		export const easeOutInBack: EasingFunction;
		export const easeOutInBounce: EasingFunction;
		export const easeOutInCirc: EasingFunction;
		export const easeOutInCubic: EasingFunction;
		export const easeOutInDeceleration: EasingFunction;
		export const easeOutInElastic: EasingFunction;
		export const easeOutInEntranceExpressive: EasingFunction;
		export const easeOutInEntranceProductive: EasingFunction;
		export const easeOutInExitExpressive: EasingFunction;
		export const easeOutInExitProductive: EasingFunction;
		export const easeOutInExpo: EasingFunction;
		export const easeOutInFabricAccelerate: EasingFunction;
		export const easeOutInFabricDecelerate: EasingFunction;
		export const easeOutInFabricStandard: EasingFunction;
		export const easeOutInMozillaCurve: EasingFunction;
		export const easeOutInQuad: EasingFunction;
		export const easeOutInQuart: EasingFunction;
		export const easeOutInQuint: EasingFunction;
		export const easeOutInRevBack: EasingFunction;
		export const easeOutInRidiculousWiggle: EasingFunction;
		export const easeOutInSharp: EasingFunction;
		export const easeOutInSine: EasingFunction;
		export const easeOutInSmooth: EasingFunction;
		export const easeOutInSmoother: EasingFunction;
		export const easeOutInSoftSpring: EasingFunction;
		export const easeOutInSpring: EasingFunction;
		export const easeOutInStandard: EasingFunction;
		export const easeOutInStandardExpressive: EasingFunction;
		export const easeOutInStandardProductive: EasingFunction;
		export const easeOutInUWPAccelerate: EasingFunction;
		export const easeOutMozillaCurve: EasingFunction;
		export const easeOutQuad: EasingFunction;
		export const easeOutQuart: EasingFunction;
		export const easeOutQuint: EasingFunction;
		export const easeOutRevBack: EasingFunction;
		export const easeOutRidiculousWiggle: EasingFunction;
		export const easeOutSharp: EasingFunction;
		export const easeOutSine: EasingFunction;
		export const easeOutSmooth: EasingFunction;
		export const easeOutSmoother: EasingFunction;
		export const easeOutSoftSpring: EasingFunction;
		export const easeOutSpring: EasingFunction;
		export const easeOutStandard: EasingFunction;
		export const easeOutStandardExpressive: EasingFunction;
		export const easeOutStandardProductive: EasingFunction;
		export const easeOutUWPAccelerate: EasingFunction;
		export const linear: EasingFunction;
	}

	/**
	 * Imperative API for controlling animations programmatically.
	 *
	 * This interface provides methods to start, stop, and pause animations
	 * without re-rendering components. The API is returned by animation hooks
	 * and the Controller class, enabling fine-grained control over animation
	 * timing and behavior.
	 *
	 * **Key Features:**.
	 *
	 * - Asynchronous operations that return Promises for chaining
	 * - Selective control over specific animation keys
	 * - Non-reactive updates that don't trigger re-renders
	 * - Stable API reference that's safe for dependency arrays.
	 *
	 * @example
	 *
	 * ```typescript
	 * const [styles, api] = useSpring(() => ({
	 * 	transparency: 1,
	 * 	scale: 1,
	 * }));
	 *
	 * // Start animation with new properties
	 * api.start({
	 * 	transparency: 0,
	 * 	scale: 1.2,
	 * 	config: { duration: 1000 },
	 * }).then(() => {
	 * 	console.log("Animation completed!");
	 * });
	 *
	 * // Control specific properties
	 * api.pause(["transparency"]); // Pause only transparency
	 * api.stop(["scale"]); // Stop only scale animation
	 *
	 * // Control all animations
	 * api.pause(); // Pause everything
	 * api.stop(); // Stop everything
	 * ```
	 *
	 * @see {@link https://www.chrisc.dev/roact-spring/docs/Common/imperatives | Imperative API Guide}
	 */
	export interface ControllerApi {
		pause(this: void, keys?: ReadonlyArray<string>): Promise<void>;
		start<TStyle extends AnimationStyle>(this: void, startProperties?: ControllerProperties<TStyle>): Promise<void>;
		stop(this: void, keys?: ReadonlyArray<string>): Promise<void>;
	}

	/**
	 * Complete set of properties for configuring spring animations.
	 *
	 * This type combines animation targets (`from`/`to` or direct style
	 * properties) with shared animation behaviors (timing, configuration,
	 * etc.). It provides the complete interface for defining how animations
	 * should behave and what values they should animate between.
	 *
	 * **Property Sources:**.
	 *
	 * - `AnimationProperties<T>` - Provides `from` and `to` animation targets
	 * - `T` - Allows direct style properties without explicit `to` wrapper
	 * - `SharedAnimationProperties` - Adds timing and behavior controls.
	 *
	 * **Usage Patterns:**.
	 *
	 * - **Explicit targets**: Use `from` and `to` properties for clear animation
	 *   endpoints - **Direct properties**: Set style properties directly for
	 *   implicit animation - **Mixed approach**: Combine both patterns as
	 *   needed.
	 *
	 * @example
	 *
	 * ```typescript
	 * // Using explicit from/to
	 * const explicitAnimation: ControllerProperties<{
	 * 	transparency: number;
	 * }> = {
	 * 	from: { transparency: 1 },
	 * 	to: { transparency: 0 },
	 * 	config: ReactSpring.config.wobbly,
	 * 	delay: 200,
	 * };
	 *
	 * // Using direct properties (implicit 'to')
	 * const directAnimation: ControllerProperties<{ scale: number }> = {
	 * 	scale: 1.5,
	 * 	config: { duration: 1000 },
	 * 	loop: true,
	 * };
	 *
	 * // Mixed approach
	 * const mixedAnimation: ControllerProperties<{
	 * 	x: number;
	 * 	y: number;
	 * }> = {
	 * 	from: { x: 0, y: 0 },
	 * 	x: 100, // Direct property
	 * 	to: { y: 50 }, // Explicit target
	 * 	immediate: false,
	 * };
	 * ```
	 *
	 * @template T - The animation style type extending AnimationStyle.
	 * @see {@link https://www.chrisc.dev/roact-spring/docs/Common/props | Animation Properties Guide}
	 */
	export type ControllerProperties<T extends AnimationStyle> = (AnimationProperties<T> | T) &
		SharedAnimationProperties;

	/**
	 * Class-based animation controller for managing springs in class
	 * components.
	 *
	 * The Controller class provides the core animation functionality of
	 * react-spring for use in class components where hooks are not available.
	 * It offers the same powerful animation capabilities as hooks but through a
	 * class-based API.
	 *
	 * **Key Features:**.
	 *
	 * - Direct instantiation with `new Controller(properties)`
	 * - Returns animated bindings and imperative API
	 * - Full compatibility with all animation properties and configurations
	 * - Suitable for class components and imperative usage patterns.
	 *
	 * **Usage Pattern:**.
	 *
	 * 1. Instantiate with initial animation properties
	 * 2. Destructure the returned tuple for styles and API
	 * 3. Use styles in component render
	 * 4. Control animations with the API methods.
	 *
	 * @example
	 *
	 * ```typescript
	 * class AnimatedComponent extends React.Component {
	 * 	constructor(props) {
	 * 		super(props);
	 *
	 * 		// Create controller with initial properties
	 * 		const [styles, api] = new ReactSpring.Controller({
	 * 			transparency: 1,
	 * 			position: UDim2.fromScale(0, 0),
	 * 			config: ReactSpring.config.wobbly,
	 * 		});
	 *
	 * 		this.styles = styles;
	 * 		this.api = api;
	 * 	}
	 *
	 * 	handleClick = () => {
	 * 		// Animate on interaction
	 * 		this.api.start({
	 * 			transparency: 0,
	 * 			position: UDim2.fromScale(1, 0),
	 * 			config: { duration: 1000 },
	 * 		});
	 * 	};
	 *
	 * 	render() {
	 * 		return React.createElement("Frame", {
	 * 			BackgroundTransparency: this.styles.transparency,
	 * 			Position: this.styles.position,
	 * 			[React.Event.MouseButton1Click]: this.handleClick,
	 * 		});
	 * 	}
	 * }
	 * ```
	 *
	 * @template T - The animation style type extending AnimationStyle.
	 * @see {@link https://www.chrisc.dev/roact-spring/docs/Additional%20Classes/controller | Controller Guide}
	 */
	export const Controller: new <T extends AnimationStyle>(
		properties: ControllerProperties<T>,
	) => LuaTuple<[{ readonly [key in keyof T]: Binding<T[key]> }, ControllerApi]>;

	/**
	 * React hook for creating single spring animations in function components.
	 *
	 * `useSpring` is the most commonly used hook in react-spring, providing an
	 * easy way to animate properties with spring physics. It supports both
	 * declarative updates (via re-renders) and imperative control (via the
	 * returned API).
	 *
	 * **Key Features:**.
	 *
	 * - Single spring animation for one set of properties
	 * - Declarative and imperative usage patterns
	 * - Automatic dependency tracking and memoization
	 * - Stable API reference across re-renders.
	 *
	 * **Usage Patterns:**.
	 *
	 * - **Declarative**: Properties update on re-render
	 * - **Imperative**: Use returned API for manual control.
	 *
	 * @example
	 *
	 * ```typescript
	 * // Declarative usage - animates on state change
	 * function DeclarativeComponent() {
	 *   const [toggle, setToggle] = React.useState(false);
	 *
	 *   const styles = useSpring({
	 *     transparency: toggle ? 0 : 1,
	 *     scale: toggle ? 1.2 : 1,
	 *     config: ReactSpring.config.wobbly
	 *   });
	 *
	 *   return (
	 *     <frame
	 *       BackgroundTransparency={styles.transparency}
	 *       Size={styles.scale.map(s => UDim2.fromOffset(s * 100, s * 100))}
	 *       Event={{
	 *         MouseButton1Click: () => setToggle(!toggle)
	 *       }}
	 *     />
	 *   );
	 * }
	 *
	 * // Imperative usage - manual control
	 * function ImperativeComponent() {
	 *   const [styles, api] = useSpring(() => ({
	 *     transparency: 1,
	 *     position: UDim2.fromScale(0, 0)
	 *   }));
	 *
	 *   const animate = () => {
	 *     api.start({
	 *       transparency: 0,
	 *       position: UDim2.fromScale(1, 1),
	 *       config: { duration: 1000 }
	 *     });
	 *   };
	 *
	 *   return (
	 *     <frame
	 *       BackgroundTransparency={styles.transparency}
	 *       Position={styles.position}
	 *       Event={{ MouseButton1Click: animate }}
	 *     />
	 *   );
	 * }
	 * ```
	 *
	 * @see {@link https://www.chrisc.dev/roact-spring/docs/Hooks/useSpring | useSpring Guide}
	 */
	export const useSpring: UseSpring;

	/**
	 * Imperative API for controlling multiple springs simultaneously.
	 *
	 * This interface extends the basic animation control methods to work with
	 * arrays of springs created by `useSprings` or `useTrail`. It allows
	 * precise control over multiple animations through callback functions that
	 * can customize properties per spring index.
	 *
	 * **Key Features:**.
	 *
	 * - Control multiple springs from a single API
	 * - Index-based customization through callback functions
	 * - Asynchronous operations with Promise-based chaining
	 * - Selective control over specific animation keys.
	 *
	 * @example
	 *
	 * ```typescript
	 * const [springs, api] = useSprings(3, (index) => ({
	 * 	transparency: 1,
	 * 	scale: 1,
	 * }));
	 *
	 * // Animate each spring with different properties
	 * api.start((index) => ({
	 * 	transparency: 0,
	 * 	scale: 1 + index * 0.2, // Different scale per index
	 * 	delay: index * 100, // Staggered timing
	 * 	config: { duration: 500 },
	 * }));
	 *
	 * // Control specific properties across all springs
	 * api.pause(["transparency"]); // Pause only transparency
	 * api.stop(["scale"]); // Stop only scale animations
	 *
	 * // Control all animations
	 * api.pause(); // Pause everything
	 * api.stop(); // Stop everything
	 * ```
	 *
	 * @template T - The animation style type extending AnimationStyle.
	 * @see {@link https://www.chrisc.dev/roact-spring/docs/Hooks/useSprings | useSprings Guide}
	 * @see {@link https://www.chrisc.dev/roact-spring/docs/Hooks/useTrail | useTrail Guide}
	 */
	export interface UseSpringsApi<T extends AnimationStyle> {
		pause(this: void, keys?: ReadonlyArray<string>): Promise<void>;
		start(this: void, callback?: (index: number) => ControllerProperties<T>): Promise<void>;
		stop(this: void, keys?: ReadonlyArray<string>): Promise<void>;
	}
	/**
	 * React hook for creating multiple spring animations simultaneously.
	 *
	 * `useSprings` allows you to animate arrays of elements with individual
	 * control over each spring's properties. Perfect for list animations, card
	 * grids, or any scenario where multiple similar elements need coordinated
	 * but distinct animations.
	 *
	 * **Key Features:**.
	 *
	 * - Create multiple springs with a single hook call
	 * - Individual property control per spring index
	 * - Declarative and imperative usage patterns
	 * - Efficient batch updates and optimizations.
	 *
	 * **Usage Patterns:**.
	 *
	 * - **Static length**: Known number of springs at render time
	 * - **Dynamic properties**: Properties can vary per spring index
	 * - **Batch animations**: Animate all springs together or individually.
	 *
	 * @example
	 *
	 * ```typescript
	 * // Declarative usage with array of items
	 * function ItemList({ items }: { items: Array<{ visible: boolean }> }) {
	 *   const springs = useSprings(
	 *     items.length,
	 *     items.map((item, index) => ({
	 *       transparency: item.visible ? 0 : 1,
	 *       scale: item.visible ? 1 : 0.8,
	 *       delay: index * 100,  // Stagger the animations
	 *       config: ReactSpring.config.wobbly
	 *     }))
	 *   );
	 *
	 *   return (
	 *     <frame>
	 *       {springs.map((style, index) => (
	 *         <frame
	 *           key={index}
	 *           BackgroundTransparency={style.transparency}
	 *           Size={style.scale.map(s => UDim2.fromOffset(s * 100, s * 50))}
	 *         />
	 *       ))}
	 *     </frame>
	 *   );
	 * }
	 *
	 * // Imperative usage with manual control
	 * function ControlledGrid() {
	 *   const [springs, api] = useSprings(9, (index) => ({
	 *     transparency: 1,
	 *     rotation: 0,
	 *     scale: 1
	 *   }));
	 *
	 *   const animateWave = () => {
	 *     api.start((index) => ({
	 *       transparency: 0,
	 *       rotation: index * 45,
	 *       scale: 1.2,
	 *       delay: index * 50,
	 *       config: { tension: 300, friction: 10 }
	 *     }));
	 *   };
	 *
	 *   return (
	 *     <frame Event={{ MouseButton1Click: animateWave }}>
	 *       {springs.map((style, index) => (
	 *         <frame
	 *           key={index}
	 *           BackgroundTransparency={style.transparency}
	 *           Rotation={style.rotation}
	 *           Size={style.scale.map(s => UDim2.fromOffset(s * 60, s * 60))}
	 *         />
	 *       ))}
	 *     </frame>
	 *   );
	 * }
	 * ```
	 *
	 * @see {@link https://www.chrisc.dev/roact-spring/docs/Hooks/useSprings | useSprings Guide}
	 */
	export const useSprings: UseSprings;

	/**
	 * React hook for creating staggered spring animations that follow each
	 * other.
	 *
	 * `useTrail` creates multiple springs where each spring follows the
	 * previous one with a configurable delay, creating elegant trailing or
	 * wave-like animations. Perfect for sequential reveals, cascading effects,
	 * and staggered list animations.
	 *
	 * **Key Features:**.
	 *
	 * - Automatic staggered timing between springs
	 * - Configurable delay between each spring (default: 0.1 seconds)
	 * - All springs share the same configuration and target values
	 * - Declarative and imperative usage patterns.
	 *
	 * **Use Cases:**.
	 *
	 * - Sequential text or element reveals
	 * - Wave animations across lists
	 * - Cascading menu or card animations
	 * - Follow-the-leader style effects.
	 *
	 * @example
	 *
	 * ```typescript
	 * // Declarative usage for text reveal
	 * function TextReveal({ show }: { show: boolean }) {
	 * 	const letters = ["H", "e", "l", "l", "o"];
	 *
	 * 	const trail = useTrail(letters.length, {
	 * 		transparency: show ? 0 : 1,
	 * 		position: show
	 * 			? UDim2.fromScale(0, 0)
	 * 			: UDim2.fromScale(0, -0.5),
	 * 		config: ReactSpring.config.wobbly,
	 * 	});
	 *
	 * 	return (
	 * 		<frame>
	 * 			{trail.map((style, index) => (
	 * 				<textlabel
	 * 					key={index}
	 * 					Text={letters[index]}
	 * 					BackgroundTransparency={style.transparency}
	 * 					Position={style.position}
	 * 				/>
	 * 			))}
	 * 		</frame>
	 * 	);
	 * }
	 *
	 * // Imperative usage with custom stagger timing
	 * function WaveAnimation() {
	 * 	const [trail, api] = useTrail(5, (index) => ({
	 * 		scale: 1,
	 * 		rotation: 0,
	 * 		transparency: 0,
	 * 	}));
	 *
	 * 	const startWave = () => {
	 * 		api.start((index) => ({
	 * 			scale: 1.5,
	 * 			rotation: 360,
	 * 			transparency: 1,
	 * 			delay: index * 200, // 200ms between each spring
	 * 			config: { tension: 200, friction: 15 },
	 * 		}));
	 * 	};
	 *
	 * 	return (
	 * 		<frame Event={{ MouseButton1Click: startWave }}>
	 * 			{trail.map((style, index) => (
	 * 				<frame
	 * 					key={index}
	 * 					BackgroundTransparency={style.transparency}
	 * 					Rotation={style.rotation}
	 * 					Size={style.scale.map((s) =>
	 * 						UDim2.fromOffset(s * 50, s * 50),
	 * 					)}
	 * 				/>
	 * 			))}
	 * 		</frame>
	 * 	);
	 * }
	 * ```
	 *
	 * @see {@link https://www.chrisc.dev/roact-spring/docs/Hooks/useTrail | useTrail Guide}
	 */
	export const useTrail: UseTrail;
}

export = ReactSpring;
export as namespace ReactSpring;
