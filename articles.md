---
title: Articles
prev: false
next: false
---

<script setup>
import { data as posts } from '/data/articles.data'
import formatDate from '/.vitepress/theme/utils/formatDate';
import getSorted from '/.vitepress/theme/utils/getSorted';
const sortedPosts = getSorted( posts );
</script>

# Articles

<ul>
  <template v-for="post of sortedPosts">
    <li v-if="!post.frontmatter.hidden">
      <strong>
        <a :href="post.url">{{ post.frontmatter.title }}</a>
      </strong>
      <br />
      <span>{{ formatDate( post.frontmatter.date ) }}</span>
    </li>
 </template>
</ul>

<style scoped>
ul {
    list-style-type: none;
    padding-left: 0;
    font-size: 1.125rem;
    line-height: 1.75;
}

li {
    display: flex;
    justify-content: space-between;
}

li span {
    font-family: var(--vp-font-family-mono);
    font-size: var(--vp-code-font-size);
}
</style>
