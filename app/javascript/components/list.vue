<template>
    <div class="list">
        <h6>{{ list.name }}</h6>
        <hr />

        <draggable v-model="list.cards" group="cards" @change="cardMoved" class="dragArea">
            <card v-for="(card, index) in list.cards" :card="card" :list="list" :key="card.id"></card>

        </draggable>

        <a v-if="!editing" v-on:click="startEditing">Add a card</a>
        <div v-if="editing" class="card card-body">
            <textarea v-model="message" ref="message" class="form-control"></textarea>
            <button v-on:click="submitMessage" class="btn btn-primary">Save</button>
            <a v-on:click="editing=false">Cancel</a>
        </div>

    </div>
</template>

<script>
import draggable from 'vuedraggable';
import card from 'components/card';

export default {
    components: { card, draggable },
    props: ["list"],
    data: function() {
        return {
            message: "",
            editing: false
        }
    },
    methods: {
        submitMessage: function() {
            var data = new FormData;
            data.append("card[list_id]", this.list.id);
            data.append("card[name]", this.message);

            Rails.ajax({
                url: "/cards",
                type: "POST",
                data: data,
                dataType: "json",
                success: (data) => {
                    // stop duplicates in poster's browser
                    //this.$store.commit('addCard', data);
                    this.message = "";
                    this.$nextTick(() => { this.$refs.message.focus() })
                }
            })
        },
        cardMoved: function(event) {
            console.log(event);

            const evt = event.added || event.moved;

            if(evt == undefined) {
                return
            }

            const element = evt.element;

            const list_index = window.store.lists.findIndex((list) => {
                return list.cards.find((card) => {
                    return card.id === element.id;
                });
            });

            var data = new FormData;
            data.append("card[list_id]", window.store.lists[list_index].id);
            data.append("card[position]", evt.newIndex + 1);

            Rails.ajax({
                url: `/cards/${element.id}/move`,
                type: "PATCH",
                data: data,
                dataType: "json"
            })
        },
        startEditing: function() {
            this.editing = true;
            this.$nextTick(() => {this.$refs.message.focus() });
        }
    }
}
</script>

<style scoped>
    .dragArea {
        min-height: 20px;
    }

</style>