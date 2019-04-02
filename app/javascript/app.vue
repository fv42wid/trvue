<template>
  <draggable v-model="lists" group="lists" @end="listMoved" class="board dragArea">

    <list v-for="(list, index) in lists" :list="list" v-bind:key="list.id"></list>

    <a v-if="!editing" v-on:click="startEditing">Add a List</a>
    <div v-if="editing" class="card card-body list">
      <textarea v-model="message" ref="message" class="form-control"></textarea>
      <button v-on:click="submitMessage" class="btn btn-primary">Save</button>
      <a v-on:click="editing=false">Cancel</a>
    </div>

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
      lists: this.original_lists,
      editing: false,
      message: ""
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
    },
    startEditing: function() {
      this.editing = true;
      this.$nextTick(() => { this.$refs.message.focus() });
    },
    submitMessage: function() {
      var data = new FormData;
      data.append("list[name]", this.message);

      Rails.ajax({
        url: "/lists",
        type: "POST",
        data: data,
        dataType: "json",
        success: (data) => {
          const index = window.store.lists.push(data);
          this.message = "";
          this.editing = false;
        }
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

.list {
  display: inline-block;
  width: 270px;
  vertical-align: top;
  margin-right: 20px;
  background: #E2E4E6;
  border-radius: 3px;
  padding: 10px;
}

</style>
