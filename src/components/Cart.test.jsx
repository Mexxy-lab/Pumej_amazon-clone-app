import React from 'react';
import { render, screen, fireEvent } from '@testing-library/react';
import Cart from './Cart';

// Mock useStateValue from StateProvider
jest.mock('../StateProvider', () => ({
  useStateValue: jest.fn(),
}));

// Import the mocked function
import { useStateValue } from '../StateProvider';

describe('Cart Component', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  test('renders empty cart message when basket is empty', () => {
    useStateValue.mockReturnValue([ { basket: [] }, jest.fn() ]);

    render(<Cart />);

    expect(
      screen.getByText(/your cart is Empty, you need to fill it up/i)
    ).toBeInTheDocument();
    expect(
      screen.getByText(/Start Adding Items to your basket/i)
    ).toBeInTheDocument();
  });

  test('renders cart items and total price correctly', () => {
    const mockBasket = [
      { id: 1, title: 'Test Item 1', price: '10.00', image: 'img1.jpg', detail: 'Some detail' },
      { id: 2, title: 'Test Item 2', price: '20.00', image: 'img2.jpg', detail: 'Another detail' },
    ];
    const mockDispatch = jest.fn();

    useStateValue.mockReturnValue([{ basket: mockBasket }, mockDispatch]);

    render(<Cart />);

    // Ensure both items render
    expect(screen.getByText('Test Item 1')).toBeInTheDocument();
    expect(screen.getByText('Test Item 2')).toBeInTheDocument();

    // Check total price (note: useEffect runs after render)
    expect(screen.getByText(/Total Price=/)).toBeInTheDocument();

    // Check for Buy Now and Remove buttons
    expect(screen.getAllByText(/Buy Now/i).length).toBeGreaterThan(0);
    expect(screen.getAllByText(/Remove from Cart/i).length).toBeGreaterThan(0);
  });

  test('dispatches Remove_From_Cart when remove button clicked', () => {
    const mockBasket = [
      { id: 99, title: 'Removable Item', price: '15.00', image: 'img.jpg', detail: 'Nice' },
    ];
    const mockDispatch = jest.fn();

    useStateValue.mockReturnValue([{ basket: mockBasket }, mockDispatch]);

    render(<Cart />);

    const removeButton = screen.getByText(/Remove from Cart/i);
    fireEvent.click(removeButton);

    expect(mockDispatch).toHaveBeenCalledWith({
      type: 'Remove_From_Cart',
      item: { id: 99, index: 0 },
    });
  });
});
