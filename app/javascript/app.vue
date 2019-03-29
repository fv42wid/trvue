<template>
  <div id="app" class="row">
    <div v-for="(list, index) in original_lists" class="col-3">
      <h6>{{ list.name }}</h6>
      <hr />

      <div v-for="(card, index) in list.cards" class="card card-body mb-3">
        {{ card.name }}
      </div>

      <div class="card card-body">
        <textarea v-model="messages[list.id]" class="form-control"></textarea>
        <button v-on:click="submitMessages(list.id)" class="btn btn-primary">Save</button>
      </div>

    </div>
  </div>
</template>

<script>
export default {
  props: ["original_lists"],
  data: function() {
    return {
      messages: {

      }
    }
  },
  methods: {
    submitMessages: function(list_id) {
      console.log(this.messages[list_id]);
    }
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
