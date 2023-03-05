import app from './app'

describe('helloWorld', () => {
  it('Should return hey', async () => {
    const result = await app()
    expect(result.body).toBe('hey')
    expect(result.statusCode).toBe(200)
  })
})
