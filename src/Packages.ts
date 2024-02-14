/* eslint-disable unicorn/prefer-export-from */
import Roact from "@rbxts/roact";
const PromiseLibrary = Promise;

namespace Packages {
	export const React = Roact;
	export const Promise = PromiseLibrary;
}

export = Packages;
