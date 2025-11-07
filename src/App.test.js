import React from "react";
import { render, screen } from "@testing-library/react";
import App from "./App";
import { MemoryRouter } from "react-router-dom";

// Mock components that trigger async state updates
jest.mock("./components/Header", () => () => <div>Header</div>);
jest.mock("./components/Banner", () => () => <div>Banner</div>);
jest.mock("./components/MainBody", () => () => <div>MainBody</div>);
jest.mock("./components/DisplayPage", () => () => <div>DisplayPage</div>);
jest.mock("./components/UserLog", () => () => <div>UserLog</div>);
jest.mock("./components/Cart", () => () => <div>Cart</div>);
jest.mock("./components/MakeCard", () => () => <div>MakeCard</div>);
jest.mock("./components/Row", () => () => <div>Row</div>);

test("renders home page without warnings", () => {
  render(
    <MemoryRouter initialEntries={["/"]}>
      <App />
    </MemoryRouter>
  );

  // Check that mocked components are rendered
  expect(screen.getByText("Header")).toBeInTheDocument();
  expect(screen.getByText("Banner")).toBeInTheDocument();
  expect(screen.getByText("MainBody")).toBeInTheDocument();
});
