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
                <input class="pkpFormField__input pkpFormField--text__input" ref="input"
                       v-model="searchPhrase"
                       @keyup="apiLookup()"
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
                locale: '{$locale}', // en, de, fr (fr_CA is shortened to fr in php)
                organizations: [], // [ { id: id1, name: 'ror_display', 'en': 'label-en', 'de': 'label-de', ... }, ... ]
                searchPhrase: '',
                minimumSearchPhraseLength: 3,
                pendingRequests: new WeakMap()
            };
        },
        methods: {
            selectOrganization(index) {
                let fields = this.$parent._props.fields;
                fields[this.getIndex('rorId')].value = this.organizations[index].id;

                let values = fields[this.getIndex('affiliation')].value;
                Object.keys(values).forEach(locale => {
                    let localeShort = locale.substring(0, 2); // locale = fr_FR > localeShort = fr
                    values[locale] = this.organizations[index].name;
                    if (typeof this.organizations[index][localeShort] !== 'undefined') {
                        values[locale] = this.organizations[index][localeShort];
                    }
                });
            },
            clearSearchPhrase() {
                this.organizations = [];
                this.searchPhrase = '';
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
                const previousController = this.pendingRequests.get(this);
                if (previousController) previousController.abort();

                if (this.searchPhrase.length < this.minimumSearchPhraseLength) return;

                const controller = new AbortController();
                this.pendingRequests.set(this, controller);

                fetch('https://api.ror.org/v2/organizations?affiliation=' + this.searchPhrase + '*', {
                    signal: controller.signal
                })
                    .then(response => response.json())
                    .then(data => {
                        this.setOrganizations(data.items);
                    })
                    .catch(error => {
                        if (error.name === 'AbortError') return;
                        console.log(error);
                    });
            },
            setOrganizations: function (items) {
                let organizations = [];

                items.forEach((item) => {

                    let rorDefault = '';
                    let row = {
                        'id': item.organization.id,
                        'name': '',
                        'en': ''
                    };

                    for (let i = 0; i < item.organization.names.length; i++) {
                        if (item.organization.names[i].types.includes('label')) {

                            if (item.organization.names[i].lang === this.locale) {
                                row.name = item.organization.names[i].value;
                            }

                            if (item.organization.names[i].types.includes('ror_display')) {
                                rorDefault = item.organization.names[i].value;
                            }

                            row[item.organization.names[i].lang] = item.organization.names[i].value;
                        }
                    }

                    // name empty, try english or names.types: ror_display
                    if (row.name === null || row.name.length === 0) {
                        row.name = rorDefault;
                        if (row.en.length > 0) {
                            row.name = row.en;
                        }
                    }

                    organizations.push(row);
                });

                this.organizations = organizations;
            }
        },
        render: function (h) {
            return rorPluginTemplateCompiled.render.call(this, h);
        }
    });
</script>
