using { my.extensions as db } from '../db/schema';

service DemoService {
    entity Orders as projection on db.Orders;
}