<script setup>
import DefaultTheme from 'vitepress/theme'

const { Layout } = DefaultTheme
</script>

<template>
  <Layout>
    <template #home-features-before>
      <div id="main-features">
        <p> Technical teams want: </p>

        <ul>
          <li> Iteration times as fast as possible </li>
          <li> To focus on their work, not the build system </li>
          <li> For the development environment to Just Work™ on any machine </li>
          <li> To onboard new contributors with zero setup </li>
          <li> Deployment to be trivial </li>
          <li> To use less compute! Better for the environment! 🌍 </li>
        </ul>

        <p> Let's get there together with <a
          href="https://nixos.org/">Nix</a>!
        </p>
      </div>
    </template>
  </Layout>
</template>

<style>

#main-features p {
  margin-top: 20px;
  margin-bottom: 20px;
}

#main-features {
  margin: 0 auto;
  display: flex;
  flex-direction: column;
  margin: 0 auto;
  padding: 0 64px;
  max-width: 1152px;
  padding-bottom: 64px;
}

#main-features p, #main-features li {
  font-size: 20px;
  line-height: 50px;
}

#main-features li {
  list-style: inside;
  margin-left: 10px;
}

</style>
