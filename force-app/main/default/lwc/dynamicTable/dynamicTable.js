import { LightningElement, track, api } from 'lwc';
import getPopUser from '@salesforce/apex/PopReminderController.getPopUser';

export default class DynamicTable extends LightningElement {
    @api columnList;
    @api title;
    @track columns;
    @track objectApiName;
    @track pickListValues;
    @track rows = [{uuid: this.createUUID()}];
    @api email;
    @api nickName;
    error;
    popUser;

    connectedCallback() {
        let cleanedColumnList = this.columnList[0] === '\\' ? this.columnList.subString(1) : this.columnList;
        if(cleanedColumnList) {
            this.columns = cleanedColumnList;
        }
        getPopUser({email: this.email, nickName: this.nickName})
        .then(result => {
            console.log('pUser: ', result);
            this.popUser = result;
        })
        .catch(err => {
            this.error = err;
        })
    }

    createUUID() { 
        return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
            var r = Math.random() * 16 | 0, v = c == 'x'? r : (r & 0x3 | 0x8);
            return v.toString(16);
        })
    }

    @api
    retrieveRecords() { 
        let rows = Array.from( this.template.querySelectorAll('tr.inputRows'));
        var records = [];
        rows.map(row => {
            let texts = Array.from(row.querySelectorAll('.fields'));
            if(texts) { 
                var textVal = this.fieldValues(texts);
                textVal.Pop_User__c = this.popUser.Id;
                records = [...records, textVal];
            }
        });
        return records;
    }

    @api
    clearRows() {
        this.rows = [{uuid: this.createUUID()}];
    }

    fieldValues(cells) {
        return cells.reduce((record, cell) => { 
            let inputVal = cell.inputValue();
            if(inputVal.value!=undefined) { 
                record[inputVal.field] = inputVal.value;
            }
            return record;
        }, {});
    }

    removeRow(event) { 
        this.rows.splice(event.target.value, 1);
    }

    addRow() { 
        this.rows.push({uuid: this.createUUID()});
    }
}