// .vitepress/theme/index.js
import DefaultTheme from "vitepress/theme-without-fonts";
import "./custom.css";
import "./fonts.css";

/* import the fontawesome core */
import { library } from "@fortawesome/fontawesome-svg-core";
/* import icons and add them to the Library */
import {
	faGolang,
	faJs,
	faPython,
	faRust,
} from "@fortawesome/free-brands-svg-icons";
/* import font awesome icon component */
import { FontAwesomeIcon } from "@fortawesome/vue-fontawesome";
import Templates from "./components/Templates.vue";
import MyLayout from "./MyLayout.vue";

library.add(faPython, faJs, faGolang, faRust);

export default {
	extends: DefaultTheme,
	Layout: MyLayout,
	enhanceApp({ app }) {
		app.component("Templates", Templates);
		app.component("FontAwesomeIcon", FontAwesomeIcon);
	},
};
