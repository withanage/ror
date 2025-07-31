{**
 * templates/contributor.tpl
 *
 * @copyright (c) 2021+ TIB Hannover
 * @copyright (c) 2021+ Gazi Yücel
 * @license Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * Ror lookup for contributor
 *}

<link rel="stylesheet" href="{$stylePath}" type="text/css"/>

{assign var="templateOpen" value='<script>let rorPluginTemplate = `'}
{assign var="templateClose" value='`;</script>'}

{$templateOpen}
<div class="pkpFormField pkpFormField--text {ROR_PLUGIN_NAME}_rorId_Lookup_div" :class="classes">
    <div class="pkpFormField__heading">
        <form-field-label :controlId="controlId" :label="label" :localeLabel="localeLabel"
                          :isRequired="isRequired" :requiredLabel="__('common.required')"
                          :multilingualLabel="multilingualLabel"></form-field-label>
        <tooltip v-if="isPrimaryLocale && tooltip" aria-hidden="true" :tooltip="tooltip" label=""></tooltip>
    </div>
    <div class="pkpFormField__control" :class="controlClasses">
        <div class="pkpFormField__control_top">
            <label>
                <span class='pkpSearch__icons'>
                    <icon icon='search' class='pkpSearch__icons--search'></icon>
                </span>
                <input class="pkpFormField__input pkpFormField--text__input" ref="input" v-model="searchPhrase"
                       :type="inputType" :id="controlId" :name="localizedName" :aria-describedby="describedByIds"
                       :aria-invalid="errors && errors.length" :disabled="isDisabled" :required="isRequired"
                       :style="inputStyles"/>
            </label>
            <button class="pkpSearch__clear" v-if="searchPhrase" @click.prevent="clearSearchPhrase">
                <icon icon="times"></icon>
            </button>
        </div>
    </div>
    <div v-if="searchPhrase" class="searchPhraseOrganizations">
        <ul>
            <li v-for="(organization, index) in organizations">
                <a @click.prevent="selectOrganization(index)">{{ organization.name }} [{{ organization.id }}]</a>
            </li>
        </ul>
    </div>
</div>
{$templateClose}

<script>
    let rorPluginTemplateCompiled = pkp.Vue.compile(rorPluginTemplate);

    pkp.Vue.component('ror-field-text-lookup', {
        name: 'RorFieldTextLookup',
        extends: pkp.Vue.component('field-text'),
        data() {
            return {
                // [ { id: id1, name: name1, labels: [ 'en': 'label1', ... }, ... ]
                organizations: [],
                searchPhrase: "",
                minimumSearchPhraseLength: 3,
            }
        },
        methods: {
            selectOrganization(index) {
                let fields = this.$parent._props.fields;
                fields[this.getIndex('rorId')].value = this.organizations[index].id;
                let values = fields[this.getIndex('affiliation')].value;
                Object.keys(values).forEach(key => {
                    values[key] = this.organizations[index].name;
                    if (typeof this.organizations[index].labels[key] !== 'undefined') {
                        values[key] = this.organizations[index].labels[key];
                    }
                });
            },
            clearSearchPhrase() {
                this.organizations = [];
                this.searchPhrase = "";
            },
            getIndex(fieldName) {
                let fields = this.$parent._props.fields;
                for (let i = 0; i < fields.length; i++) {
                    if (fields[i].name === fieldName) {
                        return i;
                    }
                }
            },
            apiLookup() {
                fetch('https://api.ror.org/v1/organizations?affiliation=' + this.searchPhrase + '*')
                    .then(response => response.json())
                    .then(data => {
                        this.organizations = [];
                        let items = data.items;
                        items.forEach((item) => {
                            let labels = { /* */};
                            for (let i = 0; i < item.organization.labels.length; i++) {
                                labels[item.organization.labels[i].iso639]
                                    = item.organization.labels[i].label
                            }
                            let row = {
                                id: item.organization.id,
                                name: item.organization.name,
                                labels: labels
                            };

                            this.organizations.push(row);
                        });
                    })
                    .catch(error => console.log(error));
            }
        },
        watch: {
            searchPhrase() {
                if (this.searchPhrase.length >= this.minimumSearchPhraseLength) {
                    this.apiLookup();
                }
            }
        },
        render: function (h) {
            return rorPluginTemplateCompiled.render.call(this, h);
        }
    });
</script>
