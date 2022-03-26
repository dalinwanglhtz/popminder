import { api, LightningElement } from 'lwc';

export default class InputDateTimeCell extends LightningElement {
    @api record;
    @api field;
    @api fieldType;
    @api type;
    value;
    label;

    get todaysDate() {
        let today = new Date();
        return today;
    }

    connectedCallback() {
        this.value = this.record[this.field];
        this.label = this.field;
        this.type = 'datetime';
    }

    handleInputChange(event) {
        this.value = event.target.value;
    }

    @api
    inputValue() {
        return {value: this.value, field: this.field};
    }

    get isDateTime() {
        if(this.fieldType) {
            return this.fieldType.toLowerCase() == 'datetime';
        }
        return false;
    }
}