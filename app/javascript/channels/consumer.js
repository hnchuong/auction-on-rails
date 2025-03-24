import { createConsumer } from "@rails/actioncable";

const consumer = createConsumer("ws://localhost:8080/cable"); // Adjust for AnyCable server

export default consumer;
