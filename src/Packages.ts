/* eslint-disable unicorn/prefer-export-from */
import ReactLibrary from "@rbxts/react";
const PromiseLibrary = Promise;

namespace Packages {
	export const React = ReactLibrary;
	export const Promise = PromiseLibrary;
}

export = Packages;
