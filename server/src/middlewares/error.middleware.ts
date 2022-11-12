import { Request, Response } from "express";

export default function errorHandler(err, req: Request, res: Response) {
  const errors = err.errors || [{ message: err.message }];
  return res.status(err.status || 500).json({ errors });
}
