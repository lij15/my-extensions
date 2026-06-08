# my-extensions

A hands-on practice project for **SAP CAP (Cloud Application Programming Model)**, focused on extending services and entities.

---

## Overview

This project explores CAP's extension mechanisms, including:

- `extend service` — adding new entities, unbound functions/actions to an existing service
- `extend entity ... with actions` — adding bound functions/actions to an existing entity
- Virtual entities (no DB backing) vs. projection entities

---

## Project Structure

```
my-extensions/
├── db/
│   └── schema.cds          # Domain models (entities, aspects, types)
├── srv/
│   ├── demo-service.cds    # Base service definition
│   ├── demo-service.js     # Base service handler
│   ├── extensions.cds      # extend service / extend entity definitions
│   └── extensions.js       # Handlers for the extended parts
├── test/
│   └── http/               # .http files for manual API testing
├── package.json
└── readme.md
```

---

## Key Concepts

### `extend service` — Add members to an existing service

```cds
extend service DemoService with {
  entity NewFoo {
    key ID : UUID;
    name   : String(50);
  };
  function getRatings1() returns Integer;  // unbound function
}
```

| Addition | Notes |
|---|---|
| `entity NewFoo { ... }` | Virtual entity — must implement CRUD manually in the handler |
| `entity Foo as projection on db.Foo` | Projection entity — CAP handles DB read/write automatically |
| `function / action` | Unbound — mounted at service level |

### `extend entity` — Add bound actions/functions to an existing entity

```cds
extend entity DemoService.Orders with actions {
  function getRatings2() returns Integer;  // bound function
}
```

OData call path: `GET /odata/v4/demo/Orders(<key>)/getRatings2()`

---

## Handler Style

This project uses the modern class-based approach throughout:

```js
module.exports = class DemoService extends cds.ApplicationService {
  async init() {

    // Unbound function
    this.on('getRatings1', async (req) => {
      return 42;
    });

    // Bound function — scoped to a specific Orders record
    this.on('getRatings2', 'Orders', async (req) => {
      const { ID } = req.params[0];
      return 99;
    });

    return super.init(); // always required
  }
}
```

> `cds.service.impl(function() { })` is the older functional style.  
> The class approach supports `init()`, inheritance, and cleaner structure — preferred for all new projects.

---

## Getting Started

```bash
npm install
cds watch
```

Service runs at: `http://localhost:4004`

---

## Testing

The `test/http/` directory contains `.http` files for manual testing with the VS Code [REST Client](https://marketplace.visualstudio.com/items?itemName=humao.rest-client) extension.

```http
### Unbound function (service level)
GET http://localhost:4004/odata/v4/demo/getRatings1()

### Bound function (entity level)
GET http://localhost:4004/odata/v4/demo/Orders(<ID>)/getRatings2()

### Virtual entity
GET http://localhost:4004/odata/v4/demo/NewFoo
POST http://localhost:4004/odata/v4/demo/NewFoo
Content-Type: application/json

{ "name": "test" }
```

---

## References

- [SAP CAP Documentation](https://cap.cloud.sap/docs)
- [CDS Language Reference — Actions & Functions](https://cap.cloud.sap/docs/cds/cdl#actions)
- [CDS Language Reference — Extend](https://cap.cloud.sap/docs/cds/cdl#extend)
- [CAP Node.js — Service Handlers](https://cap.cloud.sap/docs/node.js/core-services)
