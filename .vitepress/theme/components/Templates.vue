<template>
  <div class="templates__grid">
    <template v-for="template in items">
      <a v-if="template.live"
        target="_blank" rel="noopener" class="templates"
        :href='"https://github.com/InvariantClub/" + template.repo'>
        <article>
          <h3>
            <FontAwesomeIcon v-if="template.icon" :icon='["fa-brands", template.icon]' />
            {{template.title}}
          </h3>
          <p v-text="template.details"></p>
        </article>
      </a>
    </template>
  </div>
</template>


<script>
export default {
  props: ['items']
}
</script>

<style>

.templates__grid h3 {
  font-family: var(--vp-font-family-base);
}

.templates__grid a {
  cursor: pointer;
  text-decoration: none;
  color: black;
  font-weight: normal !important;
  border: solid 1px #00000000;
  padding: 15px;
  background: var(--vp-c-bg-soft);
}

.templates__grid a:hover {
  border: solid 1px rgb(79, 40, 204) !important;
  transition: border 0.2s ease-in-out;
}

.templates__grid {
  padding: 2rem;
  margin: 0 -4rem;
  display: grid;
  gap: 2rem;
  justify-content: center;
  grid-template-columns: repeat(auto-fit, min(320px, 80vw));
}

.templates {
  display: flex;
  flex: 1 1 auto;
  padding: 0;
  margin: 0;
  transition: opacity .2s ease-in-out;
  background: white;
  border-radius: 16px;
  overflow: hidden;
  min-height: 120px;
  align-items: center;
}

.templates h3 {
  padding: 0;
  margin: 0;
  font-weight: normal;
}

.templates img {
  margin: 0;
  max-width: 100%;
}
</style>
