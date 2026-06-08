using my.extensions as db from '../db/schema';

extend db.Bar with @title:'Bar' {
  newField : String;
  extend nestedStructField {
    newField : String;
    extend existingField @title:'Nested Field';
  }
}

extend db.Foo:nestedStructField with { newField : String; }

extend db.Books:price.value with (precision:12,scale:3);

extend db.User with (length:120);