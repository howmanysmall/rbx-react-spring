// @ts-check

import style, { GLOB_MARKDOWN_CODE } from "@isentinel/eslint-config";

export default style(
	{
		formatters: {
			css: true,
			graphql: true,
			html: true,
			lua: false,
			markdown: false,
			prettierOptions: {
				arrowParens: "always",
				bracketSameLine: false,
				bracketSpacing: true,
				checkIgnorePragma: false,
				embeddedLanguageFormatting: "auto",
				endOfLine: "auto",
				experimentalOperatorPosition: "end",
				experimentalTernaries: false,
				filepath: undefined,
				htmlWhitespaceSensitivity: "css",
				insertPragma: false,
				jsxSingleQuote: false,
				objectWrap: "preserve",
				printWidth: 120,
				proseWrap: "preserve",
				quoteProps: "as-needed",
				requirePragma: false,
				semi: true,
				singleQuote: false,
				tabWidth: 4,
				trailingComma: "all",
				useTabs: true,
				vueIndentScriptAndStyle: false,
			},
		},
		gitignore: true,
		ignores: [".lune/**", "do-not-sync-ever/**", "./data/**", "**/node_modules/**", GLOB_MARKDOWN_CODE],
		jsonc: true,
		jsx: false,
		markdown: false,
		perfectionist: {
			customClassGroups: [],
		},
		plugins: {},
		pnpm: false,
		react: true,
		roblox: true,
		rules: {
			// this is the worst lint config ever made lol
			"antfu/consistent-list-newline": "off",
			// this is stupid? and standard?
			"antfu/no-top-level-await": "off",
			"arrow-style/arrow-return-style": "off",
			"better-max-params/better-max-params": ["error", { func: 10 }],
			"comment-length/limit-multi-line-comments": "error",
			"comment-length/limit-single-line-comments": "error",
			"comment-length/limit-tagged-template-literal-comments": "error",
			curly: "off",
			"id-length": [
				"error",
				{
					exceptionPatterns: ["_"],
					max: 45,
				},
			],
			"max-lines": [
				"warn",
				{
					max: 10000,
				},
			],
			"max-lines-per-function": "off",
			// makes shit less neat
			"no-inline-comments": "off",
			"no-restricted-syntax": "off",
			// ...existing code...
			"perfectionist/sort-classes": [
				"warn",
				{
					groups: [
						// All properties first, regardless of visibility
						"static-property",
						"protected-static-property",
						"private-static-property",
						"property",
						"protected-property",
						"private-property",

						// Accessor properties (get/set)
						"protected-static-accessor-property",
						"private-static-accessor-property",
						"protected-accessor-property",
						"private-accessor-property",

						// Methods and constructor
						["get-method", "set-method"],
						"protected-static-get-method",
						"protected-static-set-method",
						"private-static-get-method",
						"private-static-set-method",
						"protected-get-method",
						"protected-set-method",
						"private-get-method",
						"private-set-method",
						"static-method",
						"protected-static-method",
						"private-static-method",
						"method",
						"constructor",
						"protected-method",
						"private-method",
					],
					order: "asc",
				},
			],
			"perfectionist/sort-objects": [
				"warn",
				{
					customGroups: {
						id: "^id$",
						name: "^name$",
						callbacks: ["\b(on[A-Z][a-zA-Z]*)\b"],
						reactProps: ["^children$", "^ref$"],
					},
					groups: ["id", "name", "unknown", "reactProps"],
					order: "asc",
					partitionByComment: "^Part:\\*\\*(.*)$",
					type: "natural",
				},
			],
			"roblox/no-user-defined-lua-tuple": "off",
			// some things are just not correct in pascal case unfortunately
			// "shopify/typescript-prefer-pascal-case-enums": "off",
			// the most annoying thing known to man
			"sonar/cognitive-complexity": "off",
			"sonar/cyclomatic-complexity": ["off", { threshold: 10 }],
			"sonar/no-commented-code": "off",
			"sonar/no-nested-incdec": "off",
			// ugly and makes max-lines-per-function even worse
			"style/padding-line-between-statements": "off",
			"test/require-hook": "off",
			"test/valid-expect": "off",
			"ts/explicit-member-accessibility": [
				"error",
				{
					accessibility: "explicit",
				},
			],
			// kid named "no operation"
			"ts/no-empty-function": "off",
			// sometimes stuff isn't added. this is unhelpful as a result.
			"ts/no-empty-object-type": "off",
			// sometimes I know shit exists, get over it
			"ts/no-non-null-assertion": "off",
			// LUAU MF
			"ts/no-require-imports": "off",
			// always wrong
			"ts/no-unnecessary-condition": "off",
			// worthless lint. always incorrect.
			"ts/no-unsafe-argument": "off",
			// worthless lint. always incorrect.
			"ts/no-unsafe-assignment": "off",
			// worthless lint. always incorrect.
			"ts/no-unsafe-call": "off",
			// worthless lint. always incorrect.
			"ts/no-unsafe-member-access": "off",
			// worthless lint. always incorrect.
			"ts/no-unsafe-return": "off",
			// "ts/no-unsafe-type-assertion": "error",
			// this is luau
			"ts/only-throw-error": "off",
			// still luau
			"ts/prefer-promise-reject-errors": "off",
			// rule conflict
			"ts/strict-boolean-expressions": "off",
			// world's most useless rule: does not care if you have a `default:`
			"ts/switch-exhaustiveness-check": "off",
			"ts/unbound-method": "off",
			// no it shouldn't lol
			"unicorn/catch-error-name": [
				"error",
				{
					name: "error",
				},
			],
			"unicorn/consistent-destructuring": "off",
			// this is just outright annoying
			"unicorn/no-keyword-prefix": "off",
			"unicorn/no-useless-undefined": ["error", { checkArguments: false, checkArrowFunctionBody: false }],
			// this piece of shit breaks OTHER apis
			"unicorn/prefer-single-call": "off",
			// democracy says goodbye!
			"unicorn/switch-case-braces": "off",
			"no-throw-literal": "off"
		},
		spellCheck: false,
		stylistic: {
			indent: "tab",
			jsx: true,
			quotes: "double",
			semi: true,
		},
		test: true,
		toml: false,
		type: "game",
		typescript: {
			parserOptions: {
				projectService: true,
				tsconfigRootDir: import.meta.dirname,
			},
			tsconfigPath: "./tsconfig.json",
			typeAware: true,
		},
		yaml: {
			overrides: {
				"yaml/indent": "error",
				"yaml/no-tab-indent": "error",
			},
		},
	},
	{
		files: ["tsconfig.json", ".vscode/extensions.json"],
		rules: {
			"jsonc/comma-dangle": "off",
		},
	},
	{
		files: ["**/*.d.ts"],
		rules: {
			"shopify/prefer-class-properties": "off",
		},
	},
	{
		files: ["src/**/*.d.ts"],
		rules: {
			"unicorn/filename-case": "off",
		},
	},
);
