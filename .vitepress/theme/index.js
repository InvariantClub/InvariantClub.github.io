// .vitepress/theme/index.js
import DefaultTheme from "vitepress/theme-without-fonts";
import "./custom.css";
import "./fonts.css";
import ArticleHeader from "./components/ArticleHeader.vue";
import Templates from "./components/Templates.vue";
import MyLayout from "./MyLayout.vue";

export default {
	extends: DefaultTheme,
	Layout: MyLayout,
	enhanceApp({ app }) {
		app.component("Templates", Templates);
		app.component("ArticleHeader", ArticleHeader);
	},
};
