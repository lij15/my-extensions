using { DemoService } from './demo-service';

extend service DemoService with {
  entity NewFoo {
    key ID   : UUID;       
    name     : String(50);
  };
  function getRatings1() returns Integer;
}

extend entity DemoService.Orders with actions {
  function getRatings2() returns Integer;
}