import fs from "fs";
import footnote from "markdown-it-footnote";
import { defineConfig } from "vitepress";

const version = "0.20.1";

const sidebar = [
	{
		text: "Resources",
		items: [
			{ text: "Articles", link: "/articles" },
			{ text: "Templates", link: "/templates/" },
			{ text: "FAQs", link: "/faqs" },
			// { text: 'Common problems', link: '/common-problems/' }
		],
	},
];

export default defineConfig({
	title: "Invariant Club",
	srcExclude: ["README.md"],
	description: "Reaching development nirvana through Nix",
	head: [
		[
			"link",
			{
				rel: "stylesheet",
				href: "//fonts.googleapis.com/css2?family=Fira+Code&family=Libre+Baskerville:ital,wght@0,400;0,700;1,400&display=swap",
			},
		],
	],

	markdown: {
		lineNumbers: true,
		theme: {
			light: "min-light",
			dark: "nord",
		},
		config: (md) => {
			md.use(footnote);
		},
	},

	// toc plugin?

	transformHead({ assets }) {
		const font = assets.find((file) =>
			/iAWriterQuattroS\.[\w-]+\.ttf/.test(file),
		);
		if (font) {
			return [
				[
					"link",
					{
						rel: "preload",
						href: font,
						as: "font",
						type: "font/ttf",
						crossorigin: "",
					},
				],
			];
		}
	},

	buildEnd(siteConfig) {
		fs.copyFile(
			process.cwd() + "/CNAME",
			siteConfig.outDir + "/CNAME",
			(e) => {},
		);
	},

	themeConfig: {
		outline: "deep",

		search: {
			provider: "local",
			options: {
				disableDetailedView: true,
				disableQueryPersistence: true,
			},
		},

		nav: [
			{ text: "Articles", link: "/articles" },
			{ text: "Templates", link: "/templates/" },
			{ text: "FAQs", link: "/faqs" },
		],

		socialLinks: [
			{ icon: "github", link: "https://github.com/InvariantClub/" },
		],

		sidebar: {
			"/articles": sidebar,
			"/templates/": sidebar,
			"/faqs": sidebar,
			// '/common-problems/': sidebar
		},

		footer: {
			message: "Built with love ❤️ on our one and only planet 🌍 :)",
		},

		lastUpdated: false,
		lastUpdatedText: "Updated on",
	},
});
