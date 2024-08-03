const App = Vue.createApp({
    data() {
        return {
            menuType: 'buy',
            items_for_buy: [],
            items_to_sell: [],
            items: [],
            enableSell: false,
            locale: 'EN',
            searchQuery: ''
        }
    },
    computed: {
        filteredItems() {
            if (this.searchQuery.trim() === '') {
                return this.items;
            }
            const query = this.searchQuery.toLowerCase();
            return this.items.filter(item => item.label.toLowerCase().includes(query));
        }
    },
    methods: {
        openMenu(type, items_for_buy, items_to_sell, enableSell, locale) {
            this.menuType = type;
            this.items_for_buy = items_for_buy || [];
            this.items_to_sell = items_to_sell || [];
            this.items = type === 'buy' ? this.items_for_buy : this.items_to_sell;
            this.enableSell = enableSell !== undefined ? enableSell : this.enableSell;
            this.locale = locale || this.locale;
            this.searchQuery = '';
            document.body.style.display = "block";
            document.getElementById('app').style.animation = "hopin 0.6s";

            const grid = document.getElementById('gridanim');
            grid.style.animation = 'none';
            grid.offsetHeight;
            grid.style.animation = 'fade 2s';
        },
        close() {
            fetch(`https://${GetParentResourceName()}/exit`);
            this.closeMenu();
        },
        selectItem(item) {
            fetch(`https://${GetParentResourceName()}/ItemManagement`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    name: item.name,
                    price: item.price,
                    label: item.label,
                    value: item.value,
                    type: this.menuType
                })
            });
        },
        closeMenu() {
            document.getElementById('app').style.animation = "hopout 0.6s";
            setTimeout(() => {
                document.body.style.display = "none";
            }, 600);
        },
        handleKeyDown(event) {
            if (event.key === "Escape") {
                this.close();
            }
        },
    },
    mounted() {
        var _this = this;
        window.addEventListener('message', function (event) {
            if (event.data.type == "show" && event.data.enable) {
                if (Array.isArray(event.data.items_for_buy) && Array.isArray(event.data.items_to_sell)) {
                    _this.openMenu(event.data.menuType, event.data.items_for_buy, event.data.items_to_sell, event.data.enableSell, event.data.locale);
                }
            }
        });
        
        window.addEventListener('keydown', this.handleKeyDown);
    }
}).mount('#app');