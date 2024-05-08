{**
 * templates/contributor.tpl
 *
 * @copyright (c) 2021+ TIB Hannover
 * @copyright (c) 2021+ Gazi Yücel
 * @license Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * Ror lookup for contributor
 * Ror Api v2: https://docs.google.com/document/d/1lYybpmtFW3cSitNAUzuVgFieco17PfuIbeVlcqcwync
 *}

<link rel="stylesheet" href="{$stylePath}" type="text/css" />

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
                       :style="inputStyles" />
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
				searchPhrase: '',
				minimumSearchPhraseLength: 3
			};
		},
		methods: {
			selectOrganization: function(index) {
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
			clearSearchPhrase: function() {
				this.organizations = [];
				this.searchPhrase = '';
			},
			getIndex: function(fieldName) {
				let fields = this.$parent._props.fields;
				for (let i = 0; i < fields.length; i++) {
					if (fields[i].name === fieldName) {
						return i;
					}
				}
			},
			apiLookup: function() {
				fetch('https://api.ror.org/v2/organizations?affiliation=' + this.searchPhrase + '*')
					.then(response => response.json())
					.then(data => {
						this.organizations = [];
						this.fillOrganizations(data.items);
					})
					.catch(error => console.log(error));
			},
			fillOrganizations: function(items) {
				items.forEach((item) => {
					let name = ''; // primary name
					let names = { /**/}; // alternative names

					for (let i = 0; i < item.organization.names.length; i++) {
						// primary name
						if (item.organization.names[i].types.includes('ror_display')
							&& item.organization.names[i].types.includes('label')) {
							name = item.organization.names[i].value;
						}

						// alternative names
						if (item.organization.names[i].lang !== null
							&& item.organization.names[i].lang.length > 0) {
							names[item.organization.names[i].lang] = item.organization.names[i].value;
						}
					}

					// primary name not found, fill from alternative names
					for (let i = 0; i < item.organization.names.length; i++) {
						if (name === null || name.length === 0) {
							name = item.organization.names[i].value;
						}
					}

					let row = {
						id: item.organization.id,
						name: name,
						labels: names
					};

					this.organizations.push(row);
				});
			}
		},
		watch: {
			searchPhrase() {
				if (this.searchPhrase.length >= this.minimumSearchPhraseLength) {
					this.apiLookup();
				}
			}
		},
		render: function(h) {
			return rorPluginTemplateCompiled.render.call(this, h);
		}
	});
</script>
