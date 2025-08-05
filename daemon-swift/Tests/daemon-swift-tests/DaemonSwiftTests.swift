import Testing

@Test("Noop test to verify test infrastructure")
func noopTest() async throws {
    #expect(true, "This test should always pass")
}

@Test("Verify basic test functionality")
func basicTest() async throws {
    let result = 1 + 1
    #expect(result == 2, "Basic math should work")
}
