const cds = require('@sap/cds')

// srv/demo-service.js  ← Main Service handler
module.exports = class DemoService extends cds.ApplicationService {
  async init() {

    // The action is a bounded action and needs to be captured using entity.on(ActionName).
    this.on('A', 'Orders', async (req) => {
        // The `req.params` method can retrieve the ID of the current order.
        return `Action A has been successfully triggered! The current order ID is: ${req.params[0].ID}`;
    });

    // unbound function：GET /odata/v4/demo/getRatings1()
    this.on('getRatings1', async (req) => {
      return 42;
    });

    // bound function：GET /odata/v4/demo/Orders(ID=<uuid>)/getRatings2()
    this.on('getRatings2', 'Orders', async (req) => {
      const { ID } = req.params[0];   // Orders key
      console.log('called on Order:', ID);
      return 99;
    });

    this.on('READ', 'NewFoo', async (req) => {
        // Returning data entirely on its own, without going through the database.
        console.log('Returning data entirely on its own, without going through the database.')
        return [{ ID: '001', name: 'hello' }];
    });

    this.on('CREATE', 'NewFoo', async (req) => {
        // Handle it yourself, such as writing to memory or calling external APIs.
        console.log('Handle it yourself, such as writing to memory or calling external APIs.')
        return req.data;
    });

    return super.init();
  }
}