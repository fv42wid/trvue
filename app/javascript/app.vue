<template>
  <draggable v-model="lists" group="lists" @end="listMoved" class="board dragArea">

    <list v-for="(list, index) in lists" :list="list" v-bind:key="list.id"></list>

  </draggable>
</template>

<script>
import draggable from 'vuedraggable';
import list from 'components/list';

export default {
  components: { draggable, list },
  props: ["original_lists"],
  data: function() {
    return {
      lists: this.original_lists
    }
  },
  methods: {
    listMoved: function(event) {
      console.log(event);
      var data = new FormData;
      data.append("list[position]", event.newIndex + 1);
      Rails.ajax({
        url: `/lists/${this.lists[event.newIndex].id}/move`,
        type: "PATCH",
        data: data,
        dataType: "json",
      })
    }
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
.dragArea {
  min-height: 20px;
}

.board {
  white-space: nowrap;
  overflow-x: auto;
}

</style>
