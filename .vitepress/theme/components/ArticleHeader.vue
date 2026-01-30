<template>
  <h1 v-text="title" />

  <small class="author-info">
    <img
      width="50"
      :src="'/images/' + image + '.png'"
    />
    by {{author}}
  </small>

</template>

<script>
export default {
  props: ['title', 'image', 'author']
}
</script>

<style>

small.author-info {
  display: flex;
  flex-direction: row;
  align-items: center;
}

small.author-info img {
  margin: 0;
  margin-right: 0.5em;
}

</style>
