namespace my.extensions;
using { managed } from '@sap/cds/common';


entity Bar {
  ID    : Integer;
  title : String(100);
  nestedStructField : {
    existingField : Integer;
  };
}

entity Foo {
    ID      :   Integer;
    name    :   String(19);
    nestedStructField : {
        sex : String(10);
    }
}

entity Books {
  key ID : UUID;
  title  : String;
  price  : {
     value : Decimal(10,2);
     currency : String(3);
  }
}

type User : String(50);


aspect NamedAspect : managed {
  price : Decimal(9,2);
} actions {
  action A() returns String;
}

entity Orders : NamedAspect {
  key ID    : UUID;
  amount    : Decimal(10,2);
}
