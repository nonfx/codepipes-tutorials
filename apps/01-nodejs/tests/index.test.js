const request = require("supertest");
const { server } = require("../src");

afterAll(() => {
  server.close();
});

describe("GET /", () => {
  it("responds with HTML", async () => {
    const res = await request(server).get("/");
    expect(res.status).toEqual(200);
    expect(res.headers["content-type"]).toMatch(/^text\/html/);
  });
});
