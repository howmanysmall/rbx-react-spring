import style, { GLOB_DTS, GLOB_MARKDOWN_CODE } from "@isentinel/eslint-config";

export default style(
	{
		formatters: {
			css: false,
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
		ignores: ["do-not-sync-ever/**", "**/node_modules/**", GLOB_MARKDOWN_CODE],
		jsdoc: {
			full: true,
		},
		markdown: false,
		perfectionist: {
			sortObjects: {
				customGroups: {
					id: "^id$",
					name: "^name$",
					callbacks: ["\b(on[A-Z][a-zA-Z]*)\b"],
					reactProps: ["^children$", "^ref$"],
				},
				groups: ["id", "name", "unknown", "reactProps"],
			},
		},
		plugins: {},
		pnpm: false,
		react: true,
		roblox: true,
		rules: {
			"antfu/consistent-list-newline": "off",
			"arrow-style/arrow-return-style": "off",
			camelcase: [
				"error",
				{
					ignoreImports: true,
				},
			],
			"comment-length/limit-multi-line-comments": [
				"error",
				{
					maxLength: 85,
				},
			],
			"comment-length/limit-single-line-comments": "error",
			"comment-length/limit-tagged-template-literal-comments": "error",
			curly: "off",
			"eslint-comments/require-description": "error",
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
					max: 9000,
				},
			],
			"max-lines-per-function": "off",
			// worthless.
			"new-cap": "off",
			// makes shit less neat
			"no-inline-comments": "off",
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
			"react-hooks-roblox/exhaustive-deps": [
				"error",
				{
					enableDangerousAutofixThisMayCauseInfiniteLoops: false,
				},
			],
			"roblox/no-user-defined-lua-tuple": "off",
			"shopify/typescript-prefer-pascal-case-enums": "error",
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
			"ts/no-empty-function": "off",
			// sometimes stuff isn't added. this is unhelpful as a result.
			"ts/no-empty-object-type": "off",
			// sometimes I know shit exists, get over it
			"ts/no-non-null-assertion": "off",
			// LUAU MF
			"ts/no-require-imports": "off",
			// wrong
			"ts/no-unnecessary-condition": "off",
			// useless
			"ts/strict-boolean-expressions": "off",
			"unicorn/catch-error-name": [
				"error",
				{
					name: "exception",
				},
			],
			"unicorn/consistent-destructuring": "off",
			// this is just outright annoying
			"unicorn/no-keyword-prefix": "off",
			// this rule is useless and conflicts
			"unicorn/no-useless-undefined": "off",
			// this piece of shit breaks OTHER apis
			"unicorn/prefer-single-call": "off",
			// democracy says goodbye!
			"unicorn/switch-case-braces": "off",
			"unused-imports/no-unused-vars": [
				"error",
				{
					argsIgnorePattern: "^_",
					varsIgnorePattern: "(?:^_|log$)",
				},
			],
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
		type: "package",
		typescript: {
			overridesTypeAware: {
				"ts/naming-convention": [
					"error",
					{
						custom: {
							match: false,
							regex: "^I[A-Z]",
						},
						format: ["PascalCase"],
						selector: "interface",
					},
				],
				"ts/only-throw-error": [
					"off",
					{
						allow: [],
					},
				],
				"ts/switch-exhaustiveness-check": ["error", { considerDefaultExhaustiveForUnions: true }],
			},
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
		files: [GLOB_DTS],
		rules: {
			"shopify/prefer-class-properties": "off",
		},
	},
);
